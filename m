Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1CEIE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:04:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55098 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CEIE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mj3c+vtWYdxKpT8lCBd1ze40Ld/Agdz3R+hoMPwcS1nVD5dTrBh+U3LW2Bzwm6/P1X
         pL0lswexs3yLTtRdyaa6qpjwbnvO1SPhuWglmgJKf2RaMvLN/zq/Ce5ZPrXWfSvsavAj
         QYRom7qN8FbbdEqqwAsTeY+Q8UKIXb7qG6DFk=
Message-ID: <4D71EE86.6030309@suse.cz>
Date: Sat, 05 Mar 2011 09:04:22 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        netdev@vger.kernel.org, maxk@qualcomm.com
Subject: tun routing is broken [was: tun: Failed to create tun sysfs files]
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>	<4D70A929.4010900@suse.cz> <20110304.010603.104076956.davem@davemloft.net> <4D70B2DC.2000005@gmail.com>
In-Reply-To: <4D70B2DC.2000005@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 10:37 AM, Jiri Slaby wrote:
> On 03/04/2011 10:06 AM, David Miller wrote:
>> From: Jiri Slaby <jslaby@suse.cz>
>> Date: Fri, 04 Mar 2011 09:56:09 +0100
>>
>>> On 03/03/2011 01:52 AM, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
>>>
>>> Hi, I'm seeing this with tun (also with earlier versions):
>>
>> The name of the attribute was changed to netdev_group in order to
>> fix this problem, in fact quite some time ago.
>>
>> See the last entry of the net_class_attributes array in
>> net/core/net-sysfs.c, if it isn't called "netdev_group"
>> something is awry.
> 
> <idiocy>
> Aha, sorry for the noise, I booted the old kernel.
> </idiocy>

Ok, so I booted the new kernel, and tun is broken there completely. If I
try to ping a vpn peer:
...
capget(0x20080522, 0, NULL)             = 0
capset(0x20080522, 0, {0, 0, 0})        = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 4
connect(4, {sa_family=AF_INET, sin_port=htons(1025),
sin_addr=inet_addr("10.20.11.1")}, 16) = -1 EINVAL (Invalid argument)

the route is:
10.20.11.1 dev tun0  proto kernel  scope link  src 10.20.11.33

When I try to ping a router on eth0 10.0.28.10, it works as expected.

Maybe the changes in ipv4 routing cause this? But my amateur eyes can't
see any breakage there...

Now I'm back in mmotm 2011-02-10-16-26 and it works, indeed.

regards,
-- 
js
suse labs
