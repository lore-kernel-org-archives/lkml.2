Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1HRQBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:01:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43754 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1HRQBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:01:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
Date: Thu, 18 Aug 2011 11:01:09 -0500
Message-ID: <CAH2r5mv9cdP_05dzmGZ_mVOswgNGVViU8Y3Z2Su+JT2Jv2TbSA@mail.gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
From: Steve French <smfrench@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Jeff Layton <jlayton@samba.org>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing from cifs kernel client to WIndows or Samba server should be much faster
than the reverse (ie large file sequential file copy to server is
faster than copying
a file from the server)  cifs kernel client serializes reads from the same file
(unless mounting forcedirectio, in which case caching is disabled) and uses
a relatively smaller read size (16K) - while for writes they are sent
in parallel
even if to the same file (and the write size is much larger e.g. 126976 bytes,
and can be set even larger to Samba).  There may be a few cases (such
as copying to WIndowsXP or Windows7) where timeouts on the
server slow things down (writing from linux client to Windows XP
or Windows 7) but what is the server type?


On Thu, Aug 18, 2011 at 7:14 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Thu, 18 Aug 2011, Justin Piszcz wrote:
>
>>
>>
>> On Thu, 18 Aug 2011, J. R. Okajima wrote:
>>
>>>
>>> Justin Piszcz:
>>>>
>>>> Does anyone know if any kernel supports CIFS w/out crashing? I'd like to
>>>> backup some CIFS shares, thanks.
>>>>
>>>>
>>>> mount -t cifs //w2/x /mnt -o user=user,pass=pass
>>>>
>>>> [  881.388836] CIFS VFS: cifs_mount failed w/return code = -22
>>>
>>>        :::
>>>
>>> Since it failed mounting, this patch will help you. Although the patch
>>> will fix one bug, there still may exist another problem.
>>>
>>> http://marc.info/?l=linux-cifs&m=131345112022031&w=2
>>
>> Hi,
>>
>> Latest patch (this one) applied to linux-3.1-rc2 works, at least it
>> mounted
>> this time and did not instantly crash the kernel!
>>
>> I also tried the hostname again (and it did not crash the kernel, but it
>> failed to mount).
>>
>> Used the IP and it mounted successfully:
>> //10.0.0.11/x          28T  5.0T   23T  19% /mnt
>> //10.0.0.11/y          19T  1.2T   18T   7% /mnt2
>>
>> It has not crashed yet (which is good), I'll apply this patch to my
>> production machine and test taking backups of this data and let you know
>> if it crashes again, thanks!
>>
>> Justin.
>
>
> Hello,
>
> It is working but very slowly:
>
> Device eth6 [10.0.1.2] (1/1):
> ================================================================================
> Incoming:                               Outgoing:
> Curr: 37.60 MByte/s                     Curr: 0.44 MByte/s
> Avg: 4.98 MByte/s                       Avg: 0.09 MByte/s
> Min: 0.00 MByte/s                       Min: 0.00 MByte/s
> Max: 40.79 MByte/s                      Max: 0.48 MByte/s
> Ttl: 1.45 GByte                         Ttl: 26.77 MByte
>
> Over 10GbE the other direction (Linux -> Windows (via Samba)) I get
> 500MiB/s, is CIFS slow?
>
> I'll look into options to tweak the speed but this is very poor speed when
> you have to transfer 5-10TB.  However, it is not crashing anymore, so any
> speed is better than that :)
>
> Justin.
>
>



-- 
Thanks,

Steve
