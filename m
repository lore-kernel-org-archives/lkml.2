Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2HTPbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:31:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2HTPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we can't get a panel mode
Date: Mon, 20 Aug 2012 10:30:57 -0500
Message-Id: <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120806045150.GA23652@thinkpad-t410>
References: <20120806045150.GA23652@thinkpad-t410>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 05:19:48PM -0500, Seth Forshee wrote:
> First, I don't have a solution for the ordering of initialization. It
> just happens to work out for me right now.

Okay, I've got a proof-of-concept implementation of delaying secondary
GPU initialization until the i2c can be muxed over to that card. It's
not exactly pretty, but it is working. I'd really like to get some
feedback on the concept and implementation before spending more time on
it. Patches follow.

One problem I'm aware of is if the switcheroo handler is in the driver
for the secondary GPU. I think this was the case for a machine I used to
have with Optimus graphics. In that scenario the secondary graphics
device is never initialized because the switcheroo handler is registered
during initialization of the secondary device. The driver load method
would need to be split up to cope with this.

Thanks,
Seth

