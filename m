Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab2AFQYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:24:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2AFQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:24:00 -0500
Message-ID: <4F072073.4040808@canonical.com>
Date: Fri, 06 Jan 2012 08:25:23 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the
 MT slot state
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 07:16 AM, Henrik Rydberg wrote:
> This patch adds the ability to extract the MT slot state sequentially
> via EVIOCGABS. The slot parameter is first selected by calling
> EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
> calls. The slot selection is local to the evdev client handler, and
> does not affect the actual input state.
> 
> Cc: Chase Douglas <chase.douglas@canonical.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry,
> 
> the first version of this patch was sent a long time ago (May 2010),
> but was put on hold due to a lack of usecases. Now, it seems such a
> case has arrived, in the X server (evdev). Some MT events may be much
> less frequent than others (ABS_MT_ORIENTATION, for example), resulting
> in wrong touch values being assumed after, say, an X restart.
> 
> I am not 100% in favor of this patch myself. Perhaps there should be a
> more explicit mechanism for selecting slots, for instance.
> 
> The patch has been tested against both 3.2 and 3.1 stable.

To bolster the claim, I have been working on the X multitouch
implementation and a library on top of it, utouch-frame. I wrote a test
case that expects the proper sequence and values of events that
propagate from the kernel to the X input module, through utouch-frame.
It was during this testing that I noticed issues that could occur if we
don't know the current values of axes in each slot.

This patch does what is says, so I'm happy to review it positively
as-is. It doesn't require a new ioctl, which is a good thing :).

Reviewed-by: Chase Douglas <chase.douglas@canonical.com>
