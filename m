Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab0KJVcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:32:21 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:53761 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab0KJVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:32:20 -0500
X-AuditID: 12074424-b7b0bae000000a05-7e-4cdb0f6330e6
From: Andy Lutomirski <luto@MIT.EDU>
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/2] Fix nouveau-related freezes
Date: Wed, 10 Nov 2010 16:32:03 -0500
Message-Id: <cover.1289423299.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
X-Brightmail-Tracker: AAAAARagEl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for resend -- apparently git-send-email doesn't like mbox files]

Nouveau takes down my system quite reliably when any hotplug event occurs.
The bug happens because the IRQ handler didn't acknowledge the hotplug
state until the bottom half, so the card generated a new interrupt
immediately, starving the bottom half and permanently starving that CPU
(and hence the bottom half).

Even with this fix, a lot of the IRQ code looks rather broken.

This is tested on 2.6.36 (and makes the system stable for me), but it also
applies cleanly to 2.6.37 (untested, but surely also necessary).  Fedora 14's
2.6.35 kernels seem to have to same problem for me, so I suspect that 2.6.35
needs this fix as well.  (All of my tests are on an NV50 card.)

Andy Lutomirski (2):
  Use existing defines for NV50 hotplug registers
  nouveau: Acknowledge HPD irq in handler, not bottom half

 drivers/gpu/drm/nouveau/nouveau_drv.h  |    5 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c |   21 +++++++++++++++------
 3 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.7.3.2

