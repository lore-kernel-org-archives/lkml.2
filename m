Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab0LNJth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:49:37 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39134 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0LNJtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:49:33 -0500
X-IronPort-AV: E=Sophos;i="4.59,341,1288584000"; 
   d="scan'208";a="26090256"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Tue, 14 Dec 2010 09:49:27 +0000
Subject: RE: [PATCH 1/3] IIO: Direct digital synthesis abi documentation
Thread-Topic: [PATCH 1/3] IIO: Direct digital synthesis abi documentation
Thread-Index: AcubClclSQ+hqIhsSb6G8JJh49qAiQAZaqyw
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324BCA8590@LIMKCMBX1.ad.analog.com>
References: <1292257644-26477-1-git-send-email-michael.hennerich@analog.com>
 <4D068C0E.1060400@cam.ac.uk>
In-Reply-To: <4D068C0E.1060400@cam.ac.uk>
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
> On 12/13/10 16:27, michael.hennerich@analog.com wrote:
> > From: Michael Hennerich <michael.hennerich@analog.com>
> >
> > Changes since RFC/v1:
> > IIO: Apply list review feedback:
> >
> > Apply list review feedback:
> >     Restructure documentation according to list feedback.
> >     Rename attributes to fit IIO convention used in other drivers.
> >     Fix typos.
> >     Provide ddsX_out_enable as opposed to ddsX_out_disable
> Hi Michael,
>
> This is more or less there. A few minor queries / suggestions
> inline.  The only major one is the mixture of X and [n] notation
> for the various indicies.  I 'think' all our docs have now moved
> to the X notation. (if not then I have messed up!)
>
> I am happy with all the actual attributes. All remaining issues
> are to do with the descriptions of what they do!
>
> Thanks,
>
> Jonathan
> >
> > Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> > Reviewed-by: Jonathan Cameron <jic23@cam.ac.uk>
> > ---
> >  .../staging/iio/Documentation/sysfs-bus-iio-dds    |   94
> ++++++++++++++++++++
> >  1 files changed, 94 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-
> dds
> >
> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
> b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
> > new file mode 100644
> > index 0000000..6791174
> > --- /dev/null
> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
> > @@ -0,0 +1,94 @@
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_freqY
> We have a hybrid here of the old indexing schemed (device[n]) and the
> new.  Either just shorten then form to
> /sys/bus/iio/.../ddsX_freqY or use
> /sys/bus/iio/devices/deviceX/ddsY_freqZ and update below appropriately.
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Stores frequency into tuning word register Y.
> Technically it might not be a register? Dropping 'register' doesn't
> to my mind change the meaning but makes it marginally more general.

ok

> > +           There can be more than one ddsX_freqY file, which allows
> for
> If there is only one wouldn't it be ddsX_freq and correspond to direct
> control rather than dependant on the tunning word?

I don't understand. In case there is only one ddsX_freqY file.
Then there is certainly no ddsX_freqsymbol or ddsX_pincontrol_freq_en file.

> The upshot of this
> is that there are always 0 or more than 1 ddsX_freqY file.
> Given we don't have any direct control cases yet that can be documented
> when/if the turn up. Hence change line above to..
> "There will be more than one ddsX_freqY file, which allows for"

We can document the missing cases once we add parts that requires them.

> > +           pin controlled FSK Frequency Shift Keying
> > +           (ddsX_pincontrol_freq_en is active) or the user can control
> > +           the desired active tuning word by writing Y to the
> > +           ddsX_freqsymbol file.
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_freqY_scale
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Scale to be applied to ddsX_freqY in order to obtain the
> > +           desired value in Hz. If shared across all frequency
> registers
> > +           Y is not present. It is also possible X is not present if
> > +           shared across all channels.
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_freqsymbol
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Specifies the active output frequency tuning word. The
> value
> > +           corresponds to the Y in ddsX_freqY. To exit this mode the
> user
> > +           can write ddsX_pincontrol_freq_en or ddsX_out_disable file.
> Is it theoretically possible to read this value when pin control is on?

Not with the AD9832/35 AD9833/34, some other DDS parts allow register readouts.
Depending on the implementation of the device in question. It might be possible
To read back the current hardware state.

I'll add the read method.

> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_phaseY
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Stores phase into phase register Y.
> Again, the mention of 'register' is a bit leading.  It's always a
> register
> so far but at least in theory it could be say several registers...

I'll change.

> > +           There can be more than one ddsX_phaseY file, which allows
> for
> Again, 'There will be'

ok

> > +           pin controlled PSK Phase Shift Keying
> > +           (ddsX_pincontrol_phase_en is active) or the user can
> > +           control the desired phase Y which is added to the phase
> > +           accumulator output by writing Y to the en_phase file.
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_phaseY_scale
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Scale to be applied to ddsX_phaseY in order to obtain the
> > +           desired value in rad. If shared across all phase registers
> > +           Y is not present. It is also possible X is not present if
> > +           shared across all channels.
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_phasesymbol
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Specifies the active phase Y which is added to the phase
> > +           accumulator output. The value corresponds to the Y in
> > +           ddsX_phaseY. To exit this mode the user can write
> > +           ddsX_pincontrol_phase_en or disable file.
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_pincontrol_en
> > +What:
>       /sys/bus/iio/devices/device[n]/ddsX_pincontrol_freq_en
> > +What:
>       /sys/bus/iio/devices/device[n]/ddsX_pincontrol_phase_en
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           ddsX_pincontrol_en: Both, the active frequency and phase is
> > +           controlled by the respective phase and frequency control
> inputs.
> > +           In case the device in question allows to independent
> controls,
> > +           then there are dedicated files (ddsX_pincontrol_freq_en,
> > +           ddsX_pincontrol_phase_en).
> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_out_enable
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_outY_enable
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           ddsX_out_enable: Enables signal generation on all outputs
> > +           of channel X.
> > +           ddsX_outY_enable: Enables signal generation on output Y,
> > +           of channel X.
> This description takes a rather different form from similar ones above.
> Perhaps it should read...
>
> ddsX_outY_enable controls signal generation on output Y of channel X. Y
> may
> be suppressed if all channels are controlled together.
>
> (we can add supression of X to the description if it ever occurs!)

ok

> > +
> > +What:              /sys/bus/iio/devices/device[n]/ddsX_outY_wavetype
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Specifies the output waveform.
> > +           (sine, triangle, ramp, square, ...)
> > +           For a list of available output waveform options read
> > +           available_output_modes.
> > +
> > +What:
>       /sys/bus/iio/devices/device[n]/ddsX_outY_wavetype_available
> > +KernelVersion:     2.6.37
> > +Contact:   linux-iio@vger.kernel.org
> > +Description:
> > +           Lists all available output waveform options.
> > --
> > 1.6.0.2
> >
> >

