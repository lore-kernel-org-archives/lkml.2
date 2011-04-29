Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1D2THA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:07:00 -0400
Received: from kroah.org ([198.145.64.141]:50256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992Ab1D2S6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.418295987@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathew McKernan <matmckernan@rauland.com.au>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Keith Packard <keithp@keithp.com>
Subject: [19/55] drm/i915/tv: Remember the detected TV type
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathew McKernan <matmckernan@rauland.com.au>

commit d5627663f2088fa4be447fdcfd52bcb233448d85 upstream.

During detect() we would probe the connection bits to determine if
there was a TV attached, and what video input type (Component, S-Video,
Composite, etc) to use. However, we promptly discarded this vital bit of
information and never propagated it to where it was used to determine
the correct modes and setup the control registers. Fix it!

This fixes a regression from 7b334fcb45b757ffb093696ca3de1b0c8b4a33f1.

Reported-and-tested-by: Mathew McKernan <matmckernan@rauland.com.au>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=35977
Signed-off-by: Mathew McKernan <matmckernan@rauland.com.au>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_tv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1380,7 +1380,9 @@ intel_tv_detect(struct drm_connector *co
 	if (type < 0)
 		return connector_status_disconnected;
 
+	intel_tv->type = type;
 	intel_tv_find_better_format(connector);
+
 	return connector_status_connected;
 }
 


