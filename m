Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0K1VzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:55:04 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59058 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0K1VzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:55:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iRYsKycJB1LgOcCuwRbHngibUyVrFufOQZg6mPznz/tTe9hl6Fd9Z2jpnrjlB6H8ii
         s5v93SAFdQ0hsvfhbA5qtuAYWhkkGXPmygnS5bOTcQihoVjhLAOO4qoBz9qHRUnRpiSE
         zFt/opzj59T73Iwvy2pA8k1zLe17tjMYryYRc=
Date: Mon, 29 Nov 2010 00:54:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: proc: proc_self_follow_link() weirdness
Message-ID: <20101128215457.GB17195@lenovo>
References: <AANLkTikqds12LikuGfYZN-BKGsxPAwoehXRUZo_jBqd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikqds12LikuGfYZN-BKGsxPAwoehXRUZo_jBqd9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 09:09:03PM +0100, Vegard Nossum wrote:
> Hi,
> 
> I came across this code in fs/proc/base.c:
> 
> static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
> {
>         struct pid_namespace *ns = dentry->d_sb->s_fs_info;
>         pid_t tgid = task_tgid_nr_ns(current, ns);
>         char *name = ERR_PTR(-ENOENT);
>         if (tgid) {
>                 name = __getname();
>                 if (!name)
>                         name = ERR_PTR(-ENOMEM);
>                 else
>                         sprintf(name, "%d", tgid);
>         }
>         nd_set_link(nd, name);
>         return NULL;
> }
> 
> This looks a bit weird to me; it seems that nd_set_link() will get
> called with name = ERR_PTR(-ENOMEM) if __getname() fails. Is this the
> intended behaviour? Shouldn't it return this ERR_PTR() instead?
> 
> 
> Vegard

nd_get_link callers do check for IS_ERR (directly or indirectly),
but to return 'name' here would be more appropriate I guess. Al?

  Cyrill
