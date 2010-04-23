Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0DWKRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:17:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35161 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009Ab0DWKR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:17:28 -0400
Date: Fri, 23 Apr 2010 11:22:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Locking question for DRM
Message-ID: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various bits of the DRM deal with minor->master:

In the case of the open helper its protected by the struct mutex.

In the release path it's protected on some paths, but not this one ...

     /* if the master has gone away we can't do anything with the lock */
        if (file_priv->minor->master)
                drm_master_release(dev, filp);

and I can't see what makes this safe if the drm_release for the master
and a client occur at the same time ?

The setmaster/dropmaster ioctl seems similar - the various conditional
checks are not protected from parallel changes occuring during their
execution.

Is this a bug or is something clever afoot ?

Alan
