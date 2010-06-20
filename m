Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0FTFhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 01:37:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0FTFhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 01:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=WZ3Om7+s+0pdMM9++yNO1KPswsTJ8DURCHt0AhN+XDSs9Y3WCBDkIxNu+oK0QAkSR5
         9Jyh8JrhOSBDWZxiCCquC2fcDdu2hnDoeiiRo94jHzj1k+KSbgo/tmyWpaCF6EqUFVOC
         Mrze11SichgMGECOEfH/Gug5HijU4fpy62kzQ=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.00.1006191622450.14879@tigran.mtv.corp.google.com>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com> 
	<alpine.DEB.1.00.1006191622450.14879@tigran.mtv.corp.google.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 20 Jun 2010 07:36:53 +0200
Message-ID: <AANLkTimt6HQZVeTtv_UO-5Lt4ngtPr0cyNXkq2YGR3lA@mail.gmail.com>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
To: Hugh Dickins <hughd@google.com>
Cc: ieidus@redhat.com, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Sun, Jun 20, 2010 at 2:02 AM, Hugh Dickins <hughd@google.com> wrote:
> Hi Michael,
>
> On Sat, 19 Jun 2010, Michael Kerrisk wrote:
>
>> Hello Hugh, Izik
>>
>> For the MADV_MERGEABLE + MADV_UNMERGEABLE changes added in 2.6.32,
>> I've written the following man-pages text. Could you please
>> review/fix/ACK.
>
> Ah, good, thanks for writing this (but I recognize many of the words ;))

(Yes ;-).)

>> Thanks to Andi and Andrew for pointers that this documentation was needed.
>
> (We did Cc you when ksm.txt went into Andrew's tree, and when it went
> on into Linus's tree: is there something more we should have done?)

Ahh -- I missed that the CC came from you. (There is currently a big backlog.)

>> --- a/man2/madvise.2
>> +++ b/man2/madvise.2
>> @@ -156,6 +157,42 @@ and the page being unmapped.
>>  This feature is intended for memory testing.
>>  This feature is only available if the kernel was configured with
>>  .BR CONFIG_MEMORY_FAILURE .
>> +.TP
>> +.BR MADV_MERGEABLE " (since Linux 2.6.32)"
>> +Enable Kernel Samepage Merging (KSM) for the pages in the range specified by
>> +.I addr
>> +and
>> +.IR len .
>> +The KSM daemon
>> +.RI ( ksmd )
>> +periodically scans those areas of user memory that have
>> +been marked as mergeable,
>> +looking for pages with identical content.
>
> I was rather puzzled by Andi calling that an internal implementation
> detail.  Okay, I suppose the "KSM daemon periodically scans" is an
> internal implementation detail, though I think it helps to warn the
> programmer of the overhead of MADV_MERGEABLE; but without "pages
> with identical content", aren't we left mystified as to just what
> this "merging" is all about?

I agree. All I had changed was to remove mention of the KSM daemon --
I just say "the kernel".

>> +These are replaced by a single write-protected page (which is automatically
>> +copied if a process later wants to update the content of the page).
>> +KSM only merges private anonymous pages (see
>> +.BR mmap (2)).
>> +The KSM feature is intended for applications that generate many
>> +instances of the same data (e.g., virtualization systems such as KVM).
>> +It can consume a lot of processing power; use with care.
>
>                                           :
>
>> +See the kernel source file
>> +.I Documentation/vm/ksm.txt
>> +for more details.
>> +The
>> +.BR MADV_MERGEABLE
>> +and
>> +.BR MADV_UNMERGEABLE
>> +operations are only available if the kernel was configured with
>> +.BR CONFIG_KSM.
>> +.TP
>> +.BR MADV_UNMERGEABLE " (since Linux 2.6.32)"
>> +Undo the effect of an earlier
>> +.BR MADV_MERGEABLE
>> +operation on the specified address range;
>> +KSM unmerges whatever pages it had merged in the address rnage specified by
>
>                                                            range

Thanks.

>> +.IR addr
>> +and
>> +.IR length .
>>  .SH "RETURN VALUE"
>>  On success
>>  .BR madvise ()
>> @@ -189,6 +226,14 @@ is not a valid value
>>  .IP *
>>  The application is attempting to release locked or shared pages (with
>>  .BR MADV_DONTNEED ).
>> +.IP *
>> +.BR MADV_MERGEABLE
>> +or
>> +.BR MADV_UNMERGEABLE
>> +was specified in
>> +.IR advice ,
>> +but the kernel was not configured with
>> +.BR CONFIG_KSM .
>>  .RE
>>  .TP
>>  .B EIO
>> @@ -221,8 +266,10 @@ for file access.
>>  .BR MADV_REMOVE ,
>>  .BR MADV_DONTFORK ,
>>  .BR MADV_DOFORK ,
>> +.BR MAD_HWPOISON ,
>
> Oh, I absolutely agree with you, MAD_HWPOISON indeed;
> but Andi might prefer MADV_HWPOISON.
>
>> +.BR MADVISE_MERGEABLE,
>
>       MADV_MERGEABLE,
>
>>  and
>> -.BR MAD_HWPOISON
>> +.BR MADVISE_UNMERGEABLE
>
>       MADV_UNMERGEABLE

D'oh!  All of the above fixed now.

Thanks!

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
