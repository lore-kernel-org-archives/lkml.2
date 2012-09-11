Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2IKFPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:15:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64188 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2IKFPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:15:09 -0400
MIME-Version: 1.0
Date: Tue, 11 Sep 2012 15:15:07 +1000
Message-ID: <CAPM=9tzq2+LO2BzEmmByeozKzX6nswi1EwvEEM_bgo9kFv1hhA@mail.gmail.com>
Subject: runtime PM and special power switches
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I've been investigating runtime PM support for some use-cases on GPUs.

In some laptops we have a secondary GPU (optimus) that can be powered
up for certain 3D tasks and then turned off when finished with. Now I
did an initial pass on supporting it without using the kernel runtime
PM stuff, but Alan said I should take a look so here I am.

While I've started to get a handle on things, we have a bit of an
extra that I'm not sure we cater for.

Currently we get called from the PCI layer which after we are finished
with our runtime suspend callback, will go put the device into the
correct state etc, however on these optimus/powerxpress laptops we
have a separate ACPI or platform driver controlled power switch that
we need to call once the PCI layer is finished the job. This switch
effectively turns the power to the card completely off leaving it
drawing no power.

No we can't hit the switch from the driver callback as the PCI layer
will get lost, so I'm wondering how you'd envisage we could plug this
in.

Dave.
