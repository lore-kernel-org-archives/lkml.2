Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab1GZHYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:24:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60556 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GZHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:24:41 -0400
MIME-Version: 1.0
X-Originating-IP: [212.120.32.74]
In-Reply-To: <1311613829-4990-1-git-send-email-keithp@keithp.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
Date: Tue, 26 Jul 2011 09:24:39 +0200
X-Google-Sender-Auth: NzSGf2f4oZoPBvJis1OM243BO7k
Message-ID: <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two things I've noticed:
- Why not dev->mode_config.mutex? I was under the impression that
mode_config.mutex protects most of the modesetting state and
dev->struct_mutex protects things related to the gpu execution cores
(i.e. all things gem), with struct_mutex nested within
mode_config.mutex. It's hazy at the edges and likely broken in tons of
corner cases, but still ... This has also the benefit that it won't
stall execbuf.
- And a nitpick: Why the dev_priv->dev indirection, when dev is
already lying around?

-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
