Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1BAOeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:34:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43065 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BAOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:33:59 -0500
Date: Tue, 1 Feb 2011 14:33:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [rtc-linux] [RFC v2 PATCH 5/7] input: pmic8058-othc: Add
	support for PM8058 based OTHC
Message-ID: <20110201143356.GB20088@sirena.org.uk>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-6-git-send-email-aghayal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296568063-12010-6-git-send-email-aghayal@codeaurora.org>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 07:17:41PM +0530, Anirudh Ghayal wrote:
> One-touch headset controller is a hardware module in Qualcomm's PMIC8058.
> It supports headset insert/remove and switch press/release detection events
> over 3 MIC BIAS lines. The MIC BIAS lines can be configured to support
> headset detection or act as regular BIAS lines.

This should probably be integrated with ASoC for management of the
biases if nothing else, though it'd also allow other stuff.  ALSA has
support for creating input devices from jacks already.

> +	input_set_capability(ipd, EV_SW, SW_HEADPHONE_INSERT);
> +	input_set_capability(ipd, EV_KEY, KEY_MEDIA);

The ALSA (well, ASoC) stuff would also allow the input device to be
merged with that for other detection methods so if you've got a headset
jack capable of detecting other things (eg, mechanical insertion or
separate mic and headphone detection).
