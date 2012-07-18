Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2GRWEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:04:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2GRWEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:04:41 -0400
Date: Wed, 18 Jul 2012 15:04:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kdump: Append newline to the last lien of vmcoreinfo
 note
Message-Id: <20120718150439.48360f16.akpm@linux-foundation.org>
In-Reply-To: <20120717173655.GC11031@redhat.com>
References: <20120717173655.GC11031@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 13:36:55 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> Last line of vmcoreinfo note does not end with \n. Parsing all the lines
> in note becomes easier if all lines end with \n instead of trying to special
> case the last line.
> 
> I know atleast one tool, vmcore-dmesg in kexec-tools tree which made the
> assumption that all lines end with \n. I think it is a good idea to
> fix it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  kernel/kexec.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c	2012-07-17 19:26:38.844033784 -0400
> +++ linux-2.6/kernel/kexec.c	2012-07-17 23:51:33.311701781 -0400
> @@ -1424,7 +1424,7 @@ static void update_vmcoreinfo_note(void)
>  
>  void crash_save_vmcoreinfo(void)
>  {
> -	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> +	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
>  	update_vmcoreinfo_note();
>  }

huh, that was a screwup.  And now we have to make what must be
viewed as a non-back-compatible ABI change.

Ho hum, presumably there isn't a lot of code out there which is
dependent upon a non-newline-terminated CRASHTIME record.

Why did this work at all, anyway?  Is CRASHTIME always the last-emitted
record?
