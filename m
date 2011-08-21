Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1HUTKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 15:10:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1HUTKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 15:10:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH 0/2 v2] sh-sci / PM: Fix problem with runtime PM callbacks run with interrupts off
Date: Sun, 21 Aug 2011 21:09:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201108202131.19479.rjw@sisk.pl>
In-Reply-To: <201108202131.19479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212109.30399.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> The sh-sci driver uses pm_runtime_get/put_sync() in such a way
> that they may be run with interrupts off and cause the (recently
> added) might_sleep_if() to trigger in rpm_suspend/resume().
> 
> To avoid that, it's necessary to set the SCI device's power.irq_safe
> flag to indicate that it's runtime PM callbacks may be executed with
> interrupts off safely.  However, the sh-sci driver needs to be able to
> clear that flag sometimes, so a new runtime PM helper for doing that
> is needed.

The previous version of this patchset was not very good as Alan pointed out,
so hopefully this one will be better.

[1/2] - Change PM subsys_data lock type into spinlock.
[2/2] - Make sh-sci use power.irq_safe to indicate that runtime PM callbacks
        may be run with interrupts off.

Thanks,
Rafael

