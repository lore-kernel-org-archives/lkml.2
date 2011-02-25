Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1BYRTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:19:52 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47367 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932411Ab1BYRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:19:50 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 25 Feb 2011 18:19:11 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
Message-ID: <20110225171911.GA22592@polaris.bitmath.org>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
 <20110224204300.GA2423@polaris.bitmath.org>
 <AANLkTi=YBYrgf66Md_G2Cas7t__BDD2nozvidYDj0p9W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=YBYrgf66Md_G2Cas7t__BDD2nozvidYDj0p9W@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1Pt1IB-0001rd-At.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Pt1IB-0001rd-At 317d586da58aa2c32caf6b1ed10f48b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> after some quick tests, I can deal with our two options (changing
> feature_mapping signature or not, and so calling feature_mapping
> before or after input_mapping).

Good, good.

> So, my questions are:
> - do we really need to change feature_mapping signature?
> - is feature_mapping tied to an input or to a device?

The input, output and feature reports are all found on the same level
in the HID protocol, so it makes sense to associate all reports with
the device itself, without any assumed association between different
reports. From a practical point of view, we may assign different input
nodes (input devices) to different input reports, so it is clear that
the mapping between hid device and input device is not 1-to-1.

For output devices, the only supported case is EV_LED, which passes
events to the input device. It is probably assumed that
HID_QUIRK_MULTI_INPUT is false for those devices. Jiri?

For feature reports, the lack of 1-1 correspondence suggests the input
device is ill-defined, and should therefore be left out of the
argument list of the callback. However, I will leave that to Jiri or
anyone more experienced with the HID layer.

Thanks,
Henrik
