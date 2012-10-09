Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2JIJjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:39:07 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:37815 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2JIJjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:39:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOTvc1CQ/khN/2dsb2JhbABFvy6BCIIgAQEBAwEBAg8BZgULCxguKC8GEyKHXQYLmnOPVpAzizmGEwOTPYItjkWBa4Jv
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="77291979"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH v2 5/6] Add a V4L2 driver for SI476X MFD
Date: Tue, 9 Oct 2012 11:38:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        halli manjunatha <hallimanju@gmail.com>
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <201210081130.28233.hverkuil@xs4all.nl> <507313FD.6050507@convergeddevices.net>
In-Reply-To: <507313FD.6050507@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091138.39054.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: I'm CC-ing Halli. Halli, can you take a look at the proposed controls?

On Mon 8 October 2012 19:57:17 Andrey Smirnov wrote:
> On 10/08/2012 02:30 AM, Hans Verkuil wrote:
> > On Sat October 6 2012 03:55:01 Andrey Smirnov wrote:
> >> This commit adds a driver that exposes all the radio related
> >> functionality of the Si476x series of chips via the V4L2 subsystem.
> >>
> >> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> >> ---
> >>  drivers/media/radio/Kconfig        |   17 +
> >>  drivers/media/radio/Makefile       |    1 +
> >>  drivers/media/radio/radio-si476x.c | 1153 ++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 1171 insertions(+)
> >>  create mode 100644 drivers/media/radio/radio-si476x.c
> >>
> >> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> >> index 8090b87..3c79d09 100644
> >> --- a/drivers/media/radio/Kconfig
> >> +++ b/drivers/media/radio/Kconfig

<snip>

> >> +static const struct v4l2_ctrl_config si476x_ctrls[] = {
> >> +	/*
> >> +	   Tuning parameters
> >> +	   'max tune errors' is shared for both AM/FM mode of operation
> >> +	*/
> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_RSSI_THRESHOLD,
> >> +		.name	= "valid rssi threshold",
> >> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> >> +		.min	= -128,
> >> +		.max	= 127,
> >> +		.step	= 1,
> >> +	},
> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_SNR_THRESHOLD,
> >> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> >> +		.name	= "valid snr threshold",
> >> +		.min	= -128,
> >> +		.max	= 127,
> >> +		.step	= 1,
> >> +	},
> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_MAX_TUNE_ERROR,
> >> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> >> +		.name	= "max tune errors",
> >> +		.min	= 0,
> >> +		.max	= 126 * 2,
> >> +		.step	= 2,
> >> +	},
> >> +	/*
> >> +	   Region specific parameters
> >> +	*/
> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_HARMONICS_COUNT,
> >> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> >> +		.name	= "count of harmonics to reject",
> >> +		.min	= 0,
> >> +		.max	= 20,
> >> +		.step	= 1,
> >> +	},
> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_DEEMPHASIS,
> >> +		.type	= V4L2_CTRL_TYPE_MENU,
> >> +		.name	= "de-emphassis",
> >> +		.qmenu	= deemphasis,
> >> +		.min	= 0,
> >> +		.max	= ARRAY_SIZE(deemphasis) - 1,
> >> +		.def	= 0,
> >> +	},
> > I think most if not all of the controls above are candidates for turning into
> > standardized controls. I recommend that you make a proposal (RFC) for this.
> >
> > This may be useful as well:
> >
> > http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html
> >
> > This patch series contains a standardized DEEMPHASIS control.
> > Note that this patch series is outdated, but patch 2/5 is OK.
> 
> So do you want me to take that patch and make it the part of this patch
> set or do you want me to create a separate RFC with a patch set that
> contains all those controls?

No, that was just FYI. I've asked Halli Manjunatha, the author of that patch
series to make a new version that can be upstreamed. The reason it was stalled
was due to a long discussion at the time how to implement multiple frequency
bands, but now that that has been resolved this patch series can move forward
as well.

> 
> Just to give some description:
> 
> SI476X_CID_RSSI_THRESHOLD, SI476X_CID_SNR_THRESHOLD,
> SI476X_CID_MAX_TUNE_ERROR are used to determine at which level of SNR,
> RSSI the station station should be considered valid and what margin of
> error is to be used(SI476X_CID_MAX_TUNE_ERROR) for those parameters.

I know that other devices (wl128x) also have similar SNR, RSSI functionality.
Halli, can you check if it would make sense to have generic controls for this?

> SI476X_CID_HARMONICS_COUNT is the amount of AC grid noise harmonics
> build-in hardware(or maybe FW) will try to filter out in AM mode.

I don't really know whether this is chip specific or not. Halli, do you
have any input on this?

> It seems to me that the controls described above are quite chip specific
> should I also include them in the RFC?

Let's wait what Halli says, but yes, it should be included in the RFC: we
want to know if this should be standardized or not, so it's good to
mention it so people are aware of this.

> >> +	{
> >> +		.ops	= &si476x_ctrl_ops,
> >> +		.id	= SI476X_CID_RDS_RECEPTION,
> >> +		.type	= V4L2_CTRL_TYPE_BOOLEAN,
> >> +		.name	= "rds",
> >> +		.min	= 0,
> >> +		.max	= 1,
> >> +		.step	= 1,
> >> +	},
> > If this control returns whether or not RDS is detected, then this control
> > should be removed. VIDIOC_G_TUNER will return that information in rxsubchans.
> 
> This control allows to turn on/off RDS processing on the radio chip
> itself. In IRQ mode in decreases the amount of
> IRQs generated by the chip. And in polling(no-IRQ) mode it decreases I2C
> traffic significantly(We've had a run of the boards that had
> 4-tuners on a single I2C bus, working in polling mode).

Ah, so this turns RDS reception on or off. You are right, there is no method
turning this on or off for receivers, only for transmitters.

This should definitely be standardized. Ideally it should be possible to set
this through VIDIOC_S_TUNER, but there isn't any field that can be used for
that. It's possible to add a field, but should we do that just for this?
I'm leaning towards a control.

An alternative is to only turn on RDS processing if read() or poll() is called.
But you might not be able to detect the presence of the RDS channel if RDS
processing is turned off as well, or can you?

Regards,

	Hans
