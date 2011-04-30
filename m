Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1D3ENd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 00:13:33 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:60360 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911Ab1D3ENb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 00:13:31 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 30 Apr 2011 00:13:24 -0400
Message-ID: <web-515901951@zbackend1.aha.ru>
In-Reply-To: <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
 <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk>
 <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
 <web-515898476@zbackend1.aha.ru>
 <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="KOI8-R"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem that the computer crashs if zip, unzip or move 
a big file, started with -rc1

The problem with the secondary reset-resistent crashs 
after a primary and-of-boot or after-boot crash started 
with -rc3 or -rc4, at least I perceived it then, but it's 
possible that it occured also before, at least then I 
didn't note it

Now I see, that nor the syslog don't contain everything 
(this was also better with 2.6.38.4).  For example, 
currently aren't logged these crashs which currently 
occure during rtc0 initializing (in addition to the other 
crashs protocolled in the log files). Also, as you can see 
from my before-last message, with the screen foto of 
/dev/pts/0 w.r.t. boot_vga, this also don't appear in the 
log file which was added at the end of the same message.

For being -rc5 , that kernel is rather bad.  I hope you 
get through to correct it until -rc10

W.Landgraf

  



=========================================================
On Fri, 29 Apr 2011 21:00:24 -0700
  Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Apr 29, 2011 at 8:39 PM, werner 
><w.landgraf@ru.ru> wrote:
>>
>> At my reclamation thread about 2.6.39-rc3,4 crashs, I 
>>informed that there
>> was a reset-resistent change of the system after crashs, 
>>so that on
>> subsequent boots (after a 'primary' crash rather at the 
>>end of booting) it
>> happened an early 'secondary' šcrash at the time of 
>>initializing ata0, with
>> funny effects like that the grafic card (or anything 
>>else) was identified as
>> an ata device, with subsequent 'read erros' on it and 
>>crash. This
>> 'secondary' effect repeated and repeated and gone away 
>>only at booting with
>> a normal kernel (2.6.38.4 or 2.6.26.2). But if 
>>afterwards booting again with
>> 2.6.39-rc3 or -rc4 , then at the end of the boot it 
>>crashed, and at
>> subsequent boots again continued this reset-resistent 
>>effect that it crasha
>> again and again with ata0 problems, until I reboot with 
>>2.6.38.4 or 2.6.26.2
>> , or waiting 5 minutes (perhaps until the memory 
>>discharged).
>>
>> All these problems dont happen with 2.6.38.4 or 2.6.26.2
> 
> Do you think you could bisect when that odd after-reset 
>behavior started?
> 
> It does sound like you have some PCI-level problem (some 
>device that
> has "sticky" state and doesn't get reset properly). Most 
>likely a
> hardware "feature" (there is various PCI hardware that 
>allows things
> like device identifiers to be written to), coupled with 
>a firmware bug
> that doesn't reset things.
> 
> But it would be intriguing to hear when it started 
>happening, so that
> we can figure out exactly _what_ isn't getting properly 
>reset..
> 
> The logfs oops may just be a result of "autodetect any 
>random
> filesystem" in that confused state. So when the state 
>isn't confused,
> you'd not see the oops, because nothing ever tries to 
>mount the
> invalid logfs image.
> 
>                 Linus
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
