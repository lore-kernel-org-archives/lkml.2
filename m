Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0FRNdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:33:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34736 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761153Ab0FRNdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HJU/ioXuQQpKE6M05MZ98jnAG7xGrmxcvdGjWEQWbw6pgD+A5KocNW3XLgAns9kyEJ
         kr2Ozobzx/GtiAfV9PbRohZT9Tbpoq8uv4vNyutXMJ8UI/jhtRzeN97Hp643YGPlpLNN
         708pChVm337PhFkWntq5Bd2J7kFRGoV/+rink=
MIME-Version: 1.0
In-Reply-To: <1276866058.28780.48.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
	<1276866058.28780.48.camel@e102109-lin.cambridge.arm.com>
Date: Fri, 18 Jun 2010 18:55:13 +0530
Message-ID: <AANLkTimjLtQJmfjW31aRMPyY9XTVCwNCfTR_JU_0apbd@mail.gmail.com>
Subject: Re: Probable Bug (or configuration error) in kmemleak
From: Sankar P <sankar.curiosity@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, rnagarajan@novell.com,
       teheo@novell.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 6:30 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, 2010-06-18 at 09:11 +0100, Sankar P wrote:
>> On Thu, Jun 17, 2010 at 11:06 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Thu, Jun 17, 2010 at 02:21:56AM -0700, Sankar P wrote:
>> >> Hi,
>> >>
>> >> I wanted to detect memory leaks in one of my kernel modules. So I
>> >> built Linus' tree  with the following config options enabled (on top
>> >> of make defconfig)
>> >>
>> >> CONFIG_DEBUG_KMEMLEAK=y
>> >> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
>> >> CONFIG_DEBUG_KMEMLEAK_TEST=y
>> >>
>> >> If I boot with this kernel, debugfs is automatically mounted. But I do
>> >> not have the file:
>> >>
>> >> /sys/kernel/debug/kmemleak
>> >>
>> >> created at all. There are other files like kprobes in the mounted
>> >> /sys/kernel/debug directory btw. So I am not able to detect any of the
>> >> memory leaks. Is there anything I am doing wrong or missing (or) is
>> >> this a bug in kmemleak ?
>> >>
>> >> Please let me know your suggestions to fix this and get memory leaks
>> >> reporting working. Thanks.
>> >>
>> >> The full .config file is also attached with this mail. Sorry for the
>> >> attachment, I did not want to paste 5k lines in the mail. Sorry if it
>> >> is wrong.
>> >
>> >
>> > This is odd.. Do you see this message on your kernel ring buffer?
>> >
>> > Failed to create the debugfs kmemleak file
>> >
>>
>> I dont see such an error in the dmesg output. But I got another
>> interesting error:
>>
>> [    0.000000] kmemleak: Early log buffer exceeded, please increase
>> DEBUG_KMEMLEAK_EARLY_LOG_SIZE
>> [    0.000000] kmemleak: Kernel memory leak detector disabled
>
> You would need to increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE. The default of
> 400 seems ok for me but it may not work with some other kernel
> configurations (that's a static array for logging memory allocations
> before the kmemleak is fully initialised and can start tracking them).
>
>> But after that also, I see some other lines like:
>>
>> [    0.511641] kmemleak: vmalloc(64) = f7857000
>> [    0.511645] kmemleak: vmalloc(64) = f785a000
>
> This is because you compiler the test module into the kernel
> (DEBUG_KMEMLEAK_TEST). It's not kmemleak printing this but it's testing
> module (which leaks memory on purpose).
>
>> The variable  DEBUG_KMEMLEAK_EARLY_LOG_SIZE was set to 400 by default.
>> I changed it to 4000 and then 40000 (may be should try < 32567 ?) but
>> still I get the same error message and the file
>> /sys/kernel/debug/kmem* is never created at all.
>
> This shouldn't usually happen with values greater than 2000. From your
> kernel log, the version seems to be 2.6.32. Do you have the same
> problems with 2.6.35-rc3?
>
> Your .config seems to refer to the 2.6.35-rc3 kernel - are you checking
> the right image?
>

Ah sorry. I am testing by ssh into a remote machine. After installing
my kernel (after increasing the DEBUG_KMEMLEAK_EARLY_LOG_SIZE), Before
rebooting, I forgot to change the default-kernel this time. I will
check once again and will let you know. Thank you a lot for the
"dmesg" pointer.


-- 
Sankar P
http://psankar.blogspot.com
