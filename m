Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1BXUlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:41:53 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36241 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687Ab1BXUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:41:49 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 24 Feb 2011 21:43:00 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
Message-ID: <20110224204300.GA2423@polaris.bitmath.org>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1Pshzy-0005ff-6q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Pshzy-0005ff-6q 79de67ecdc0e0afe00108682b8b1d399
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 08:50:55PM +0100, Benjamin Tissoires wrote:
> Hi Henrik,
> 
> Thanks for spotting this. BTW, I'm not happy with your solution.
> 
> You are sending the feature report before creating the struct
> hid_input. To be consistent with the rest, we have to keep the same
> signature. Today, the code does not make any use of it. But I use it
> in my devel branch to auto-detect the maximum contact count of the
> device. This was the safest place to call input_mt_init_slots.

Well, the whole point is "which input device". It would only be
well-defined when the hid device has a single input device. The
feature callback could be called last, however, if that helps.

> How about adding hidinput as an argument to report_features
> 
> and calling it after the " for (k = HID_INPUT_REPORT; k <=
> HID_OUTPUT_REPORT; k++) {" loop with
> 
> list_for_each_entry_safe(hidinput, next, &hid->inputs, list)
>     report_features(hid, hidinput);
> 
> I did not even try to compile it right now (I don't have any
> multitouch device right now) but I'll be able to make further tests
> tomorrow.

Thanks,
Henrik
