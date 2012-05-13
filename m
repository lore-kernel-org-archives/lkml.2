Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2EMQSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:18:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47373 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab2EMQSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:18:31 -0400
Date: Sun, 13 May 2012 17:18:29 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Herrmann <dh.herrmann@googlemail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/7] drm: do not change selected options based on EXPERT
 mode
In-Reply-To: <1336925230-2853-8-git-send-email-dh.herrmann@googlemail.com>
Message-ID: <alpine.DEB.2.00.1205131716490.12347@skynet.skynet.ie>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com> <1336925230-2853-8-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> EXPERT mode is designed to toggle visibility of config options. It should
> not have any other effect on config values. Imagine if a user wants to
> tweak a single value that is protected by EXPERT mode. If they enable
> EXPERT mode to change that single option, they might get side effects from
> other subsystems which they didn't expect. This makes EXPERT mode totally
> useless. Hence, simply let the user always select the framebuffer-console
> manually.
> Furthermore, with kmscon or wayland, users might want to disable CONFIG_VT
> which is currently automatically selected by DRM_KMS_HELPER through
> FRAMEBUFFER_CONSOLE if !EXPERT.

NAK,

not going to happen, the whole point is that we get FRAMEBUFFER_CONSOLE 
selected, the number of bugs filed where people build kernels with kms
and forget the console is why we did this, it would be stupid to undo it.

The !EXPERT thing was added just for the kmscon/wayland use case, where
some expert was configuring the kernel.

Dave.
