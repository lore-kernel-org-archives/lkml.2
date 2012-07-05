Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2GEPBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2GEPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <1341475102-10433-1-git-send-email-haodong@linux.vnet.ibm.com>
References: <1341475102-10433-1-git-send-email-haodong@linux.vnet.ibm.com>
Date: Thu, 5 Jul 2012 23:01:20 +0800
Message-ID: <CAM_iQpU-RTQWxRr1p7WNn4Homz9eitOeOQuB120cdhawOjZDJA@mail.gmail.com>
Subject: Re: [PATCH] lib/kobject: simplify function kobject_init
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:58 PM, Dong Hao <haodong@linux.vnet.ibm.com> wrote:
>         if (kobj->state_initialized) {
>                 /* do not error out as sometimes we can recover */
> -               printk(KERN_ERR "kobject (%p): tried to init an initialized "
> -                      "object, something is seriously wrong.\n", kobj);
> -               dump_stack();
> +               err_str = "tried to init an initialized object, something is seriously wrong.";
> +               goto error;

You missed the comment:

   /* do not error out as sometimes we can recover */
