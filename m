Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab2JHXPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:15:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53587 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766Ab2JHXPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:15:15 -0400
Message-ID: <1349738114.15802.27.camel@joe-AO722>
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
From: Joe Perches <joe@perches.com>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, arve@android.com
Date: Mon, 08 Oct 2012 16:15:14 -0700
In-Reply-To: <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
References: <n> <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 00:31 +0530, Anmol Sarma wrote:
> Changed all user visible multi-line stings to single line.

Another patch might be to add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include and

> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -556,8 +556,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		goto free_range;
>  
>  	if (vma == NULL) {
> -		pr_err("binder: %d: binder_alloc_buf failed to "
> -		       "map pages in userspace, no vma\n", proc->pid);
> +		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> +			proc->pid);

remove all the "binder: " prefixes like:

		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
		       proc->pid);


