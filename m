Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0FTAC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 20:02:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0FTAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 20:02:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=un/DxWr8Fus2ZXMexAH9X/oh8ebIrZfzGpMNZntpENpLKwTpir3lkhsbsWefh7MXa
	dxV3YfKQn3hTDiGrk52CA==
Date: Sat, 19 Jun 2010 17:02:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: ieidus@redhat.com, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
In-Reply-To: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.1006191622450.14879@tigran.mtv.corp.google.com>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sat, 19 Jun 2010, Michael Kerrisk wrote:

> Hello Hugh, Izik
> 
> For the MADV_MERGEABLE + MADV_UNMERGEABLE changes added in 2.6.32,
> I've written the following man-pages text. Could you please
> review/fix/ACK.

Ah, good, thanks for writing this (but I recognize many of the words ;))

> 
> Thanks to Andi and Andrew for pointers that this documentation was needed.

(We did Cc you when ksm.txt went into Andrew's tree, and when it went
on into Linus's tree: is there something more we should have done?)

> 
> Thanks,
> 
> Michael
> 
> 
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -156,6 +157,42 @@ and the page being unmapped.
>  This feature is intended for memory testing.
>  This feature is only available if the kernel was configured with
>  .BR CONFIG_MEMORY_FAILURE .
> +.TP
> +.BR MADV_MERGEABLE " (since Linux 2.6.32)"
> +Enable Kernel Samepage Merging (KSM) for the pages in the range specified by
> +.I addr
> +and
> +.IR len .
> +The KSM daemon
> +.RI ( ksmd )
> +periodically scans those areas of user memory that have
> +been marked as mergeable,
> +looking for pages with identical content.

I was rather puzzled by Andi calling that an internal implementation
detail.  Okay, I suppose the "KSM daemon periodically scans" is an
internal implementation detail, though I think it helps to warn the
programmer of the overhead of MADV_MERGEABLE; but without "pages
with identical content", aren't we left mystified as to just what
this "merging" is all about?

> +These are replaced by a single write-protected page (which is automatically
> +copied if a process later wants to update the content of the page).
> +KSM only merges private anonymous pages (see
> +.BR mmap (2)).
> +The KSM feature is intended for applications that generate many
> +instances of the same data (e.g., virtualization systems such as KVM).
> +It can consume a lot of processing power; use with care.

                                           :

> +See the kernel source file
> +.I Documentation/vm/ksm.txt
> +for more details.
> +The
> +.BR MADV_MERGEABLE
> +and
> +.BR MADV_UNMERGEABLE
> +operations are only available if the kernel was configured with
> +.BR CONFIG_KSM.
> +.TP
> +.BR MADV_UNMERGEABLE " (since Linux 2.6.32)"
> +Undo the effect of an earlier
> +.BR MADV_MERGEABLE
> +operation on the specified address range;
> +KSM unmerges whatever pages it had merged in the address rnage specified by

                                                            range

> +.IR addr
> +and
> +.IR length .
>  .SH "RETURN VALUE"
>  On success
>  .BR madvise ()
> @@ -189,6 +226,14 @@ is not a valid value
>  .IP *
>  The application is attempting to release locked or shared pages (with
>  .BR MADV_DONTNEED ).
> +.IP *
> +.BR MADV_MERGEABLE
> +or
> +.BR MADV_UNMERGEABLE
> +was specified in
> +.IR advice ,
> +but the kernel was not configured with
> +.BR CONFIG_KSM .
>  .RE
>  .TP
>  .B EIO
> @@ -221,8 +266,10 @@ for file access.
>  .BR MADV_REMOVE ,
>  .BR MADV_DONTFORK ,
>  .BR MADV_DOFORK ,
> +.BR MAD_HWPOISON ,

Oh, I absolutely agree with you, MAD_HWPOISON indeed;
but Andi might prefer MADV_HWPOISON.

> +.BR MADVISE_MERGEABLE,

       MADV_MERGEABLE,

>  and
> -.BR MAD_HWPOISON
> +.BR MADVISE_UNMERGEABLE

       MADV_UNMERGEABLE

>  are Linux-specific.
>  .SH NOTES
>  .SS "Linux Notes"

Thanks!
Hugh
