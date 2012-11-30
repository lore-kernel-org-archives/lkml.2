Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2K3FsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:48:05 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:39968 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2K3FsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:48:03 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 00:48:03 EST
MIME-Version: 1.0
In-Reply-To: <CAMR3sdoaP3+Gk9w9Hp=qFcP5qXq77Fe0OVYR=NARtkA_x=YE+g@mail.gmail.com>
References: <CAMR3sdoaP3+Gk9w9Hp=qFcP5qXq77Fe0OVYR=NARtkA_x=YE+g@mail.gmail.com>
Date: Thu, 29 Nov 2012 21:25:49 -0800
Message-ID: <CAK7N6vqL39aJG2n-yi6yG0nf-3Hm9OKGn4YOMeqXjnX1zoxfYQ@mail.gmail.com>
Subject: Re: Function show_uevent@drivers/base/core.c
From: anish singh <anish198519851985@gmail.com>
To: Roger Yang <netyrj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 7:37 PM, Roger Yang <netyrj@gmail.com> wrote:
> drivers/base/core.c
>
> static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
>                             char *buf)
>  {
>          ....
>
>         kset = top_kobj->kset;
>          if (!kset->uevent_ops || !kset->uevent_ops->uevent)
>                  goto out;
>
>         /* respect filter */
>  -       if (kset->uevent_ops && kset->uevent_ops->filter)
>  +       if (kset->uevent_ops->filter)
>                  if (!kset->uevent_ops->filter(kset, &dev->kobj))
>                          goto out;
>
>         env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
>          if (!env)
>                  return -ENOMEM;
what is the problem?
>
>         ...
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
