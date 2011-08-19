Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1HSMua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:50:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1HSMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:50:28 -0400
Date: Fri, 19 Aug 2011 07:50:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: =?utf-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>
Cc: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
Message-ID: <20110819125025.GA17925@thinkpad-t410>
Mail-Followup-To: =?utf-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>,
	JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Chase Douglas <chase.douglas@canonical.com>,
	Henrik Rydberg <rydberg@euromail.se>,
	Alessandro Rubini <rubini@cvml.unipv.it>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw>
 <20110818173959.GE28313@thinkpad-t410>
 <87hb5ddcsa.fsf@emc.com.tw>
 <20110819121308.GA16386@thinkpad-t410>
 <4E4E59DD.7000005@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E4E59DD.7000005@tudelft.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:41:01PM +0200, Éric Piel wrote:
> Op 19-08-11 14:13, Seth Forshee schreef:
> >On Fri, Aug 19, 2011 at 04:29:57PM +0800, JJ Ding wrote:
> >>>You should only report the ABS_[XY] coordinates when fingers != 0. The
> >>>xorg synaptics module sees the values reported in that case as
> >>>legitimate. This is causing me to see strange behaviors when scrolling
> >>>with two-finger drags.
> >>AFAIK, though v2 and v3 differ in packet format, they really report the
> >>same data to the userspace. In this version of v3 support, I even try to
> >>make v2 and v3 report all the data in the same sequnce. If you're seeing
> >>this issue, maybe we should do the same with v2?
> >
> >Actually neither v1 nor v2 reports ABS_[XY] unless fingers != 0. In v2
> >the reporting is in a switch statement on the number of fingers, and 0
> >is unhandled.
> 
> Yes, in other words, in the case of v1 or v2, the switch(fingers)
> does nothing if fingers == 0.
> 
> Maybe you could do put these 3 lines inside a "if (fingers != 0)":
> +	input_report_abs(dev, ABS_X, x1);
> +	input_report_abs(dev, ABS_Y, y1);
> +	elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);

I don't think elantech_report_semi_mt_data() should be moved inside the
condition. It's doing the right thing when fingers is 0.
