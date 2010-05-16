Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0EPTlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:41:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab0EPTlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:41:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Sun, 16 May 2010 21:42:39 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
In-Reply-To: <1273810273-3039-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005162142.39343.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010, Arve Hjønnevåg wrote:
> This patch series adds a suspend-block api that provides the same
> functionality as the android wakelock api. This version has some
> changes from, or requested by, Rafael. The most notable changes are:
> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
>   for statically allocated suspend blockers. 
> - suspend_blocker_destroy is now called suspend_blocker_unregister
> - The user space mandatory _INIT ioctl has been replaced with an
>   optional _SET_NAME ioctl.
> 
> I kept the ack and reviewed by tags on two of the patches even though
> there were a few cosmetic changes.

I have one more comment, sorry for that.

Namely, if /sys/power/policy is set to "opportunistic" and "mem" is written
into /sys/power/state and there are no suspend blockers present except for
the main blocker (and the blockers used only for statistics), the system won't
be able to go out of an infinit suspend-resume loop (or at least it seems
so from reading the code).

I think we should prevent that from happening somehow.

Thanks,
Rafael


