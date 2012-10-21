Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JUBFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 21:05:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53135 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082Ab2JUBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 21:05:14 -0400
Message-ID: <1350781512.16706.3.camel@joe-AO722>
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
From: Joe Perches <joe@perches.com>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: gregkh@linuxfoundation.org, swetland@google.com, arve@android.com,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 20 Oct 2012 18:05:12 -0700
In-Reply-To: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
References: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> Fixed all instances of strings spanning multiple lines from checkpatch.pl.
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -556,7 +556,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		goto free_range;
>  
>  	if (vma == NULL) {
> -		pr_err("binder: %d: binder_alloc_buf failed to "
> +		pr_err("binder: %d: binder_alloc_buf failed to " \
>  		       "map pages in userspace, no vma\n", proc->pid);

Hi Ken.

Nice try, but the "right" way to do this is to coalesce formats like:

		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
		       proc->pid);

and ignore 80 column line lengths for these coalesced formats.

An even better way is to add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include and change the format to:

		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
		       proc->pid);


