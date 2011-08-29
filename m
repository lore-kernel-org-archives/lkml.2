Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1H2HOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:14:24 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:54449 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1H2HOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:14:17 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89r?= =?utf-8?Q?ic?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v3 7/7] Input: elantech - add v3 hardware support
In-Reply-To: <20110826142813.GB13381@thinkpad-t410>
References: <1314320591-11551-1-git-send-email-jj_ding@emc.com.tw> <1314320591-11551-8-git-send-email-jj_ding@emc.com.tw> <20110826142813.GB13381@thinkpad-t410>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 29 Aug 2011 15:16:16 +0800
Message-ID: <87vctgsn5r.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 09:28:13 -0500, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Fri, Aug 26, 2011 at 09:03:11AM +0800, JJ Ding wrote:
> > +	/*
> > +	 * check debounce first, it has the same signature in byte 0 
> 
> Just one pedantic comment -- git complained about trailing whitespace on
> this line. Not that important, and Dmitry can clean it up when he
> applies the patch if he's so inclined.
> 
> This patch looks good now, and it's testing fine for me.
> 
> Reviewed-and-Tested-by: Seth Forshee <seth.forshee@canonical.com>
Thank you very much for viewing and testing this code, Seth.
> 
> I'm also curious what you found out about whether or not the touchpad
> does accurate finger tracking. I've played with it a little, and the
> finger tracking has been accurate except for one small exception. When
> the fingers are overlapping on one axis the touchpad always reports the
> same position for both fingers along that axis. For instance, if I move
> one finger up and the other finger down simultaneously on the touchpad,
> one of the fingers will show reverse movement on the y axis briefly
> while the fingers overlap. But I've never seen the fingers swap between
> the two frames of the packet.
I just got confirmed that with v3, two finger touch always gets reported
separately. I will resend this series for this update.
Add what you observed is actually hardware limitation. The v3 hardware
only has a projective sensor. When two fingers are overlapping along x or
y axis, the hardware can only sense one on that axis, once the two
fingers are away from the "crossing zone", they get reported separately again.

jj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
