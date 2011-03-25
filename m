Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1CYBEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:04:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36377 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1CYBEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QHG5SBYRlagV6lAf3eJl+RwxLALlhvIB9mtDxAu+eIsi7SPp3ca8nl/Xxaqz5D3uu0
         Tg6o4KUXdZR6flvfWEui691abseA8SN27Xdlk1f5gMnvLJYAA8mF365C0YfAdDoGYuv+
         dz9QIkBxKqmLGcybNrpIAi8oRtacNowtT7530=
MIME-Version: 1.0
In-Reply-To: <AANLkTinh9Li7DGgSqcZ+p9peS5XrHWomerSvKTYwHZ9-@mail.gmail.com>
References: <1301005107.2714.113.camel@edumazet-laptop>
	<AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
	<1301005946.2714.130.camel@edumazet-laptop>
	<20110324.153623.45921344.davem@davemloft.net>
	<1301006652.2714.145.camel@edumazet-laptop>
	<AANLkTi=Xb3KCBKoVCcaVD5iyCtMCAnYaGF_DTeFQ0ays@mail.gmail.com>
	<AANLkTinh9Li7DGgSqcZ+p9peS5XrHWomerSvKTYwHZ9-@mail.gmail.com>
Date: Fri, 25 Mar 2011 02:04:44 +0100
Message-ID: <AANLkTi=hgOcwO8ojQBtmqbROS1qrhm5HCmq7tRxesc=6@mail.gmail.com>
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 1:53 AM, Kyle Moffett <kyle@moffetthome.net> wrote:
> On Thu, Mar 24, 2011 at 20:12, Alessandro Suardi
> <alessandro.suardi@gmail.com> wrote:
>> On Thu, Mar 24, 2011 at 11:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> Le jeudi 24 mars 2011 à 15:36 -0700, David Miller a écrit :
>>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>>> Date: Thu, 24 Mar 2011 23:32:26 +0100
>>>>
>>>> > Then it doesnt work anymore because it parses an ipip field from
>>>> > ip route get ...
>>>> >
>>>> > $ ip ro get 192.168.1.1
>>>> > 192.168.1.1 dev wlan0  src 192.168.1.21
>>>> >     cache  ipid 0x784c mtu 1500 advmss 1460 hoplimit 64
>>>> >
>>>> >
>>>> > Maybe you upgraded iproute2
>>>>
>>>> I'm leaning towards app bug too.
>>>>
>>>> These default metrics wouldn't get printed before, but now because of
>>>> how metrics are handled, they will.
>>>>
>>>> Userland needs to cope properly with this.
>>>
>>>
>>> BTW, ipip is not always printed (even on old kernels) : One needs to
>>> actually need ipip generation .
>>>
>>> edumazet@edumazet-laptop:~$ ping 4.4.4.4
>>> PING 4.4.4.4 (4.4.4.4) 56(84) bytes of data.
>>> ^C
>>>
>>> edumazet@edumazet-laptop:~$ ip ro get 4.4.4.4
>>> 4.4.4.4 dev ppp0  src 10.150.51.210
>>>    cache  mtu 1500 advmss 1460 hoplimit 64
>>>
>>> edumazet@edumazet-laptop:~$ ping -s 2000 4.4.4.4
>>> PING 4.4.4.4 (4.4.4.4) 2000(2028) bytes of data.
>>> ^C
>>>
>>> edumazet@edumazet-laptop:~$ ip ro get 4.4.4.4
>>> 4.4.4.4 dev ppp0  src 10.150.51.210
>>>    cache  ipid 0xf99a mtu 1500 advmss 1460 hoplimit 64
>>>
>>>
>>> This on a 2.6.35 kernel
>>>
>>> I suspect Alessandro tool had a bug anyway.
>>
>> I still contend this is a kernel regression :)
>>
>>
>> vpnc is a custom build from trunk as of June 2010, with openssl support
>>  to talk to my corporate VPN concentrator:
>>
> [...snip...]
>>
>> My iproute package, on this up-to-date Fedora 14 x86_64, has last been
>>  updated on 20 Nov 2010, and back then I was running 2.6.37-rc2-git4
>>  (I keep around my historical .config files, so I know for sure).
>>
>> [root@duff ~]# ip -V
>> ip utility, iproute2-ss100804
>> [root@duff ~]# rpm -qf /sbin/ip
>> iproute-2.6.35-6.fc14.x86_64
>>
>> The behavior of this version of 'ip' as invoked by this version of 'vpnc'
>>  is something that has worked for the last 4 months, and isn't working
>>  right now. Furthermore, previous versions of 'ip' in Fedora 14 were
>>  also working with the same 'vpnc', which means it's actually 9 months
>>  minimum of working behavior.
>>
>> If some change in the kernel broke my userspace, this usually qualifies
>>  as a regression.
>>
>> That said, if you can point me to a working version of iproute with the
>>  current kernel, I have no problem in upgrading it :)
>
> Historically you could usually take the text output of "ip route get"
> and feed it right back to "ip route add", and it would work, but this
> was never guaranteed.
>
> Recently, the "ip route get" command started printing extra statistics
> (like "ipid") after the other information, but obviously those
> statistics are not valid for an "ip route add" command.
>
> The kernel bug was that the "ip" command was not always getting those
> statistics from the kernel, so obviously they would not be printed.
>
> Unfortunately vpnc still tries to pass the entire output of "ip route
> get" as arguments to "ip route add"; the latter command reports an
> error when it gets the statistics from the former command as input.
>
> So this is certainly not a kernel bug.  At *best* it's an iproute bug,
> depending on whether or not this is considered valid:
>  RT="$(ip route get [...])"
>  ip route flush
>  ip route add ${RT}

Fair enough, I get it.

Looks like the fix_ip_get_output() function in /etc/vpnc/vpnc-script
 needs to be augmented from the current

  sed 's/cache//;s/metric \?[0-9]\+ [0-9]\+//g;s/hoplimit [0-9]\+//g'

 to something slightly more comprehensive.


Thanks for the explanation - will keep around -git2 for my vpnc
 needs until I get this one sorted out :)

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
