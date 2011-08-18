Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1HROZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:25:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1HROZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:25:03 -0400
Date: Thu, 18 Aug 2011 09:25:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
Message-ID: <20110818142500.GC28313@thinkpad-t410>
Mail-Followup-To: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
	Eric Piel <E.A.B.Piel@tudelft.nl>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Chase Douglas <chase.douglas@canonical.com>,
	Henrik Rydberg <rydberg@euromail.se>,
	Alessandro Rubini <rubini@cvml.unipv.it>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw>
 <20110818135853.GA28313@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818135853.GA28313@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 08:58:53AM -0500, Seth Forshee wrote:
> The case 3 code is nearly identical to case 2. How about this?
> 
> 	case 2:
> 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> 		/* fall through */
> 
> 	case 3:
> 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
> 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
> 		/* range of pressure and width is the same as v2 */
> 		input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
> 				     ETP_PMAX_V2, 0, 0);
> 		input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
> 				     ETP_WMAX_V2, 0, 0);
> 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
> 		input_mt_init_slots(dev, 2);
> 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
> 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
> 		break;

Sorry, that should have been:

	case 2:
		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
		/* fall through */

	case 3:
		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
		if (etd->reports_pressure) {
			input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
					     ETP_PMAX_V2, 0, 0);
			input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
					     ETP_WMAX_V2, 0, 0);
		}
		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
		input_mt_init_slots(dev, 2);
		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
		break;
