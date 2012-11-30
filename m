Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2K3Doi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:44:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44207 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2K3Doh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:44:37 -0500
MIME-Version: 1.0
Date: Fri, 30 Nov 2012 11:37:25 +0800
Message-ID: <CAMR3sdoaP3+Gk9w9Hp=qFcP5qXq77Fe0OVYR=NARtkA_x=YE+g@mail.gmail.com>
Subject: Function show_uevent@drivers/base/core.c
From: Roger Yang <netyrj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/base/core.c

static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
                            char *buf)
 {
         ....

        kset = top_kobj->kset;
         if (!kset->uevent_ops || !kset->uevent_ops->uevent)
                 goto out;

        /* respect filter */
 -       if (kset->uevent_ops && kset->uevent_ops->filter)
 +       if (kset->uevent_ops->filter)
                 if (!kset->uevent_ops->filter(kset, &dev->kobj))
                         goto out;

        env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
         if (!env)
                 return -ENOMEM;

        ...
 }
