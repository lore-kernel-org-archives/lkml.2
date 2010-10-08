Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab0JHO6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:58:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60409 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0JHO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:58:07 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-input@vger.kernel.org, xorg-devel@lists.x.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
Date: Fri,  8 Oct 2010 10:57:57 -0400
Message-Id: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobyn Bertram reverse engineered the multitouch protocol for Synaptics devices.
I've been able to take his work and produce a series of commits to enable MT
and multifinger (MF) support.

Unfortunately, there's a tricky issue with some Synaptics touchpads that have
integrated buttons. For example, the left and right buttons on the touchpad of
my Dell Mini 1012 consist of the lower ~20% of the touchpad surface. The
touchpad physically clicks under these areas.

The X synaptics input module now has a parameter to disable touches occuring
over the button area, but this solution still doesn't work perfectly. If you
click a button and drag with another finger near the clicking finger, the
touchpad gets confused.

Now that we have full MT support, we can try to handle this scenario better.
What I've found to work best is to make touches vanish if they occur over the
button area of the trackpad while any button is held. This works in conjunction
with the X synaptics driver to disable single touch control over the button
area. With full MT support, the touchpad doesn't seem to get confused when a
click and drag occurs with two fingers close to each other, and it enables MT
gestures and MF support across the entire trackpad when no buttons are held.

The first question is whether this seems appropriate to others, or if some
other method would work better. Secondarily, should the solution occur in the
kernel, like I have in the third patch of this series, or should it occur in
the X input module? Although we don't have this information today, we may be
able to query the touchpad in the future to know the area of the integrated
buttons. If that were possible, would the recommended location for the hack
change?

Thanks,

-- Chase
