Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1GFLWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:22:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1GFLWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <201107052038.p65Kc1SM022560@imap1.linux-foundation.org>
References: <201107052038.p65Kc1SM022560@imap1.linux-foundation.org>
Date: Wed, 6 Jul 2011 14:22:42 +0300
Message-ID: <CACVxJT_Jrk3O4N89w_JxcVhu50H5nVBJgiBwVbD3mpHoqSVAhQ@mail.gmail.com>
Subject: Re: + procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch
 added to -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ogino.daisuke@jp.fujitsu.com, hch@lst.de,
        jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 11:38 PM,  <akpm@linux-foundation.org> wrote:

> --- a/fs/proc/inode.c~procfs-return-enoent-on-opening-a-being-removed-proc-entry
> +++ a/fs/proc/inode.c
> @@ -321,7 +321,7 @@ static int proc_reg_open(struct inode *i
>        if (!pde->proc_fops) {
>                spin_unlock(&pde->pde_unload_lock);
>                kfree(pdeo);
> -               return -EINVAL;
> +               return -ENOENT;

Yeah, this makes more sense.
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
