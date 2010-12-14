Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0LNKQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:16:39 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50390 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0LNKQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:16:37 -0500
X-IronPort-AV: E=Sophos;i="4.59,341,1288584000"; 
   d="scan'208";a="26163138"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Tue, 14 Dec 2010 10:16:31 +0000
Subject: RE: [PATCH 2/3] IIO: dds.h convenience macros
Thread-Topic: [PATCH 2/3] IIO: dds.h convenience macros
Thread-Index: AcubC7lR+RiTxHnCRqS72rr3mGTkzwAawtHg
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324BCA85C6@LIMKCMBX1.ad.analog.com>
References: <1292257644-26477-1-git-send-email-michael.hennerich@analog.com>
 <1292257644-26477-2-git-send-email-michael.hennerich@analog.com>
 <4D068E5E.4060707@cam.ac.uk>
In-Reply-To: <4D068E5E.4060707@cam.ac.uk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jonathan Cameron wrote on 2010-12-13:
> > On 12/13/10 16:27, michael.hennerich@analog.com wrote:
> > From: Michael Hennerich <michael.hennerich@analog.com>
> >
> > Changes since RFC/v1:
> > IIO: Apply list review feedback
> >
> > Apply list review feedback:
> >     Rename attributes to fit IIO convention used in other drivers.
> >     Provide ddsX_out_enable as opposed to ddsX_out_disable.
> >     Fix typos.
> > Hi Michael,
>
> I'm afraid all the comments on docs carry over to this file.  If you
> aren't particularly attached to having docs in here I'd be tempted to
> drop them purely so we don't end up with two differing sets in the
> future.  The docs file is more or less obligatory whereas nice docs
> in here is just a bonus for driver devs.  I really don't mind, but
> we'll have to keep a close eye to ensure they don't get significantly
> out of sync!

I'll drop the descriptions within the comments, but keep the file names.

> The other comments are almost all about restricting parameters to be
> write only. I think this is a bit restrictive and some drivers may
> allow much of this stuff to be read back (even if only from cache).

The parts I looked at so far were write only parts, but right you are.
I'll add the read methods to the macros.

> Jonathan
> > Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> > ---
> >  drivers/staging/iio/dds/dds.h |  152
> +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 152 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/staging/iio/dds/dds.h
> >
> > diff --git a/drivers/staging/iio/dds/dds.h
> b/drivers/staging/iio/dds/dds.h
> > new file mode 100644
> > index 0000000..a8dd7be
> > --- /dev/null
> > +++ b/drivers/staging/iio/dds/dds.h
> > @@ -0,0 +1,152 @@
> > +/*
> > + * dds.h - sysfs attributes associated with DDS devices
> > + *
> > + * Copyright (c) 2010 Analog Devices Inc.
> > + *
> > + * Licensed under the GPL-2 or later.
> > + */
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_freqY
> > + * Description:
> > + * Stores frequency into tuning word register Y.
> > + * There can be more than one ddsX_freqY file, which allows for pin
> controlled
> > + * FSK Frequency Shift Keying (ddsX_pincontrol_freq_en is active) or
> the user
> > + * can control the desired active tuning word by writing Y to the
> > + * ddsX_freqsymbol file.
> > + */
> > +
> > +#define IIO_DEV_ATTR_FREQ(_device, _num, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_freq##_num, S_IWUSR, NULL, _store,
> _addr)
> Can envision some parts allowing this to be read back. So I'd be
> inclined
> to make mode a parameter of the macro and allow a read function.  Also
> is _device
> a little misleading?  Perhaps use _channel?

Right, channel fits better.

> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_freqY_scale
> > + * Description:
> > + * Scale to be applied to ddsX_freqY in order to obtain the
> > + * desired value in Hz. If shared across all frequency registers
> > + * Y is not present.
> > + */
> > +
> > +#define IIO_CONST_ATTR_FREQ_SCALE(_device, _string)
>       \
> > +   IIO_CONST_ATTR(dds##_device##_freq_scale, _string)
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_freqsymbol
> > + * Description:
> > + * Specifies the active output frequency tuning word. The value
> corresponds
> > + * to the Y in ddsX_freqY. To exit this mode the user can write
> > + * ddsX_pincontrol_freq_en or ddsX_out_disable file.
> > + */
> > +
> > +#define IIO_DEV_ATTR_FREQSYMBOL(_device, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_freqsymbol,                      \
> > +                   S_IWUSR, NULL, _store, _addr);
> Again I can envision parts for which this may be read back so this is
> probably
> to restrictive.
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_phaseY
> > + * Description:
> > + * Stores phase into phase register Y.
> > + * There can be more than one ddsX_phaseY file, which allows for pin
> controlled
> > + * PSK Phase Shift Keying (ddsX_pincontrol_phase_en is active) or
> the user can
> > + * control the desired phase Y which is added to the phase
> accumulator output
> > + * by writing Y to the en_phase file.
> > + */
> > +
> > +#define IIO_DEV_ATTR_PHASE(_device, _num, _store, _addr)           \
> > +   IIO_DEVICE_ATTR(dds##_device##_phase##_num,                     \
> > +                   S_IWUSR, NULL, _store, _addr)
> Another one that I think should allow reading (if the driver wants to
> provide
> it anyway!)
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_phaseY_scale
> > + * Description:
> > + * Scale to be applied to ddsX_phaseY in order to obtain the
> > + * desired value in rad. If shared across all phase registers
> > + * Y is not present.
> > + */
> > +
> > +#define IIO_CONST_ATTR_PHASE_SCALE(_device, _string)
>       \
> > +   IIO_CONST_ATTR(dds##_device##_phase_scale, _string)
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_phasesymbol
> > + * Description:
> > + * Specifies the active phase Y which is added to the phase
> accumulator output.
> > + * The value corresponds to the Y in ddsX_phaseY. To exit this mode
> the user
> > + * can write ddsX_pincontrol_phase_en or disable file.
> > + */
> > +
> > +#define IIO_DEV_ATTR_PHASESYMBOL(_device, _store, _addr)           \
> > +   IIO_DEVICE_ATTR(dds##_device##_phasesymbol,                     \
> > +                   S_IWUSR, NULL, _store, _addr);
> Another that I'd imagine some drivers may allow to be read back.
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_pincontrol_en
> > + * Description:
> > + * Both, the active frequency and phase is controlled by the
> respective
> > + * phase and frequency control inputs.
> > + */
> > +
> > +#define IIO_DEV_ATTR_PINCONTROL_EN(_device, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_pincontrol_en,                   \
> > +                   S_IWUSR, NULL, _store, _addr);
> ditto.
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_pincontrol_freq_en
> > + * Description:
> > + * The active frequency is controlled by the respective
> > + * frequency control/select inputs.
> > + */
> > +
> > +#define IIO_DEV_ATTR_PINCONTROL_FREQ_EN(_device, _store, _addr)
>               \
> > +   IIO_DEVICE_ATTR(dds##_device##_pincontrol_freq_en,              \
> > +                   S_IWUSR, NULL, _store, _addr);
> ditto.
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_pincontrol_phase_en
> > + * Description:
> > + * The active phase is controlled by the respective
> > + * phase control/select inputs.
> > + */
> > +
> > +#define IIO_DEV_ATTR_PINCONTROL_PHASE_EN(_device, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_pincontrol_phase_en,             \
> > +                   S_IWUSR, NULL, _store, _addr);
> ditto
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_out_enable
> > + * Description:
> > + * Disables any signal generation on all outputs.
> > + */
> > +
> > +#define IIO_DEV_ATTR_OUT_ENABLE(_device, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_out_enable,                      \
> > +                   S_IWUSR, NULL, _store, _addr);
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_outY_enable
> > + * Description:
> > + * Disables any signal generation on output Y.
> Comment is lagging changes in the macro.
> > + */
> > +
> > +#define IIO_DEV_ATTR_OUTY_ENABLE(_device, _output, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_out##_output##_enable,           \
> > +   S_IWUSR, NULL, _store, _addr);
> Why write only?
> > +
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_outY_wavetype
> > + * Description:
> > + * Specifies the output waveform. (sine, triangle, ramp, square,
> ...)
> > + * For a list of available output waveform options read
> available_output_modes.
> > + */
> > +#define IIO_DEV_ATTR_OUT_WAVETYPE(_device, _output, _store, _addr)
>       \
> > +   IIO_DEVICE_ATTR(dds##_device##_out##_output##_wavetype,
>       \
> > +                   S_IWUSR, NULL, _store, _addr);
>
> > +/**
> > + * /sys/bus/iio/devices/device[n]/ddsX_outY_wavetype_available
> > + * Description:
> > + * Lists all available output waveform options.
> > + */
> > +#define IIO_CONST_ATTR_OUT_WAVETYPES_AVAILABLE(_device, _output,
> _modes)\
> > +   IIO_CONST_ATTR(dds##_device##_out##_output##_wavetype_available,\
> > +                   _modes);
> > --
> > 1.6.0.2
> >
> >

