Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0KZX6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 18:58:04 -0500
Received: from mail.perches.com ([173.55.12.10]:1874 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0KZX6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 18:58:02 -0500
Subject: Re: [PATCH] proc: make proc entry's len "unsigned int"
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101126211033.GA14339@core2.telecom.by>
References: <20101126211033.GA14339@core2.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:58:00 -0800
Message-ID: <1290815880.11971.323.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 23:10 +0200, Alexey Dobriyan wrote:
> Space is not really conserved, because of natural alignment for the next field.

It can be.  Depends on the arch.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
[]
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -50,7 +50,7 @@ typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
>  
>  struct proc_dir_entry {
>  	unsigned int low_ino;
> -	unsigned short namelen;
> +	unsigned int namelen;
>  	const char *name;
>  	mode_t mode;
>  	nlink_t nlink;

mode_t is unsigned short on many platforms.

Layout order in this struct should probably be:

	const char *name;
	unsigned short namelen;
	mode_t mode;


