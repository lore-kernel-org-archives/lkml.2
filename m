Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab0FJOVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:21:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43551 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0FJOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:21:53 -0400
Subject: Re: [PATCH 0/3] input: evdev: Dynamic buffers (rev4)
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
In-Reply-To: <1275735869-2185-1-git-send-email-rydberg@euromail.se>
References: <1275735869-2185-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 10:21:47 -0400
Message-ID: <1276179707.24373.29.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 13:04 +0200, Henrik Rydberg wrote:
> Dmitry,
> 
> Please find enclosed the fourth version of the evdev buffer patches.
> 
> This version implements buffer locking using event_lock as you
> suggested, such that we can proceed with fixing the evdev buffer
> problem independently from providing a suitable one-to-many buffer.
> 
> The first patch converts the per-client buffers to a common buffer,
> and adds a fixme since the code is expected to be further
> improved. The second and third patch includes your review comments.
> 
> Thanks,
> Henrik
> 
> ---
> 
> Henrik Rydberg (3):
>   input: evdev: Use multi-reader buffer to save space (rev4)
>   input: evdev: Convert to dynamic event buffer (rev4)
>   input: Use driver hint to compute the evdev buffer size (rev2)
> 
>  drivers/input/evdev.c |   68 +++++++++++++++++++++++++++++++++----------------
>  include/linux/input.h |   17 ++++++++++++
>  2 files changed, 63 insertions(+), 22 deletions(-)

I like the first patch for the simplification of buffer management into
one buffer per device, and I think it may be more efficient due to there
being less locking when syncing the clients.

The second and third patches seem like reasonable solutions to the
buffers being too small for some devices that can handle many MT events
simultaneously and offer many attributes per event.

Acked-by: Chase Douglas <chase.douglas@canonical.com>

