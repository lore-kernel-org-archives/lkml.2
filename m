Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab0EDSVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:21:21 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:55438 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145Ab0EDSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:21:19 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org,
       guy.paradis@n-trig.com
Subject: [PATCH 0/3] N-Trig improved filtering
Date: Tue,  4 May 2010 14:20:14 -0400
Message-Id: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guy, sorry to drop this just after your kind letter yesterday.  This change
has been in the works for a little while, and would have been sent in last
week if I hadn't found an error in my model.


Sorry to send these patches as such large chunks.


In the current version of hid-ntrig, contacts are rejected based on a simple
size threshold to filter out randomly generated activity.  Unfortunately
I was too aggressive in the selection of that threshold.  As Micki may have
pointed out we can improve the responsiveness of the 12" inch devices.  Its
actually been pretty good, but there was definitely room for improvement.
However, the 17" studio laptop with the ntrig sensor still uses the same
logical range which results in a decrease in the perceived size of a contact.
Consequently, one needs a fairly substantial contact area to hit the threshold
that was hard coded.

Since I still don't fully understand the source of the noise, and don't have
an accurate characterization, I've used what I have observed to create filters
that should enable noise reduction/elimination as well as improve the
sensitivity.  Since I don't actually know what the optimal defaults are, and
since the behavior of the screen seems to change from time to time, I'd like
to expose the tuning parameters to the user.

Perhaps between feedback from users and hopefully some advice from ntrig, we
can select sensible defaults.


On a side note, I haven't really used module parameters and sysfs before.
What I wrote works fine, and I tried to follow the style of examples.  Still
I'd like some feedback of what I did wrong, or right.


Rafi
