Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab2CJJ4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 04:56:54 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3577 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2CJJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 04:56:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: halli manjunatha <manjunatha_halli@ti.com>
Subject: Re: [PATCH 3/3] wl128x: Add sysfs based support for FM features
Date: Sat, 10 Mar 2012 10:56:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc1-durdane; KDE/4.6.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>, shahed@ti.com
References: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com> <201203090929.15663.hverkuil@xs4all.nl> <CAMT6PydCfihD45nxJXvLOM-dW_khjiLK0W+oeegi_W_EsU5MBg@mail.gmail.com>
In-Reply-To: <CAMT6PydCfihD45nxJXvLOM-dW_khjiLK0W+oeegi_W_EsU5MBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203101056.41461.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 09, 2012 21:44:10 halli manjunatha wrote:
> On Fri, Mar 9, 2012 at 2:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Wednesday, March 07, 2012 22:42:05 halli manjunatha wrote:
> >> On Mon, Mar 5, 2012 at 10:24 AM, halli manjunatha <hallimanju@gmail.com> wrote:
> >> > On Fri, Mar 2, 2012 at 3:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> >> On Wednesday, February 29, 2012 18:19:27 halli manjunatha wrote:
> >> >>> On Wed, Feb 29, 2012 at 5:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> >>> > On Tuesday, February 28, 2012 23:52:21 halli manjunatha wrote:
> >> >>> >> On Tue, Feb 28, 2012 at 4:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> >>> >> > On Monday, February 27, 2012 17:29:18 halli manjunatha wrote:
> >> >>> >> >> Hi Hans,
> >> >>> >> >>
> >> >>> >> >> Agreed I don't mind to create new controls for below things
> >> >>> >> >>
> >> >>> >> >> 1) FM RX Band selection (US/Europe, Japan and Russian bands)
> >> >>> >> >> 2) FM RX RDS AF turn ON/OFF
> >> >>> >> >> 3) FM RX RSSI level set/get
> >> >>> >> >> 4) FM TX Alternate Frequency set/get
> >> >>> >> >> 5) FM RX De-Emphasis mode set/get
> >> >>> >> >>
> >> >>> >> >> However, previously you have suggested me to hide few controls (like
> >> >>> >> >> band selection) from the user but few of our application wanted
> >> >>> >> >> controls like above and that is why I have created the sysfs entries.
> >> >>> >> >>
> >> >>> >> >> Please suggest me how can I move forward with new controls or with sysfs?
> >> >>> >> >
> >> >>> >> > The first question is which of these controls are general to FM receivers or
> >> >>> >> > transmitters, and which are specific to this chipset. The chipset specific
> >> >>> >> > controls should be private controls (look at V4L2_CID_MPEG_CX2341X_BASE in
> >> >>> >> > videodev2.h how those are defined). The others should be defined as new
> >> >>> >> > controls of the FM_TX class or the FM_RX class. The FM_RX class should be
> >> >>> >> > defined as a new class as it doesn't exist at the moment. Don't forget to
> >> >>> >> > document these controls clearly.
> >> >>> >> >
> >> >>> >> > With regards to the band selection: I remember that there was a discussion,
> >> >>> >> > but not the details. Do you have a link to that discussion? I can't find it
> >> >>> >> > (at least not quickly :-) ).
> >> >>> >>
> >> >>> >> Below features are generic to all FM receivers so we can add new CID's
> >> >>> >> for below features
> >> >>> >> 1) FM RX RDS AF turn ON/OFF
> >> >>> >> 2) FM TX Alternate Frequency set/get
> >> >>> >>
> >> >>> >> About other 3 features its different issue,
> >> >>> >>     1) FM RX Band selection (US/Europe, Japan and Russian bands)
> >> >>> >>     2) FM RX RSSI level set/get
> >> >>> >>     3) FM RX De-Emphasis mode set/get
> >> >>> >>
> >> >>> >> All these 3 features are generic to any FM receiver, only question is
> >> >>> >> does all FM receivers wants to expose these controls to application
> >> >>> >> writer?
> >> >>> >
> >> >>> > Good question, and there is no good answer at the moment. See e.g. this
> >> >>> > IRC discussion:
> >> >>> >
> >> >>> > http://www.spinics.net/lists/linux-media/msg44023.html
> >> >>> >
> >> >>> > In the absence of a good solution to this problem I am inclined to make
> >> >>> > these controls driver specific but marked experimental. The experimental
> >> >>> > tag allows us to eventually make it a generic control without too much
> >> >>> > hassle.
> >> >>>
> >> >>> Agreed, I will make them driver specific and mark them as experimental.
> >> >>>
> >> >>> >
> >> >>> >> Example Band selection, every FM receiver at the minimum supports both
> >> >>> >> Europe and Japan band, now the question is should we add a CID to
> >> >>> >> switch between these two bands?
> >> >>> >
> >> >>> > If we decide to add a band selection control, then that would be a menu
> >> >>> > control (since there are up to three bands) and it would only be implemented
> >> >>> > by drivers that need it.
> >> >>> >
> >> >>> > What I am still not clear on is *why* you would want this control. What
> >> >>> > is the reason your customers want this? What does it allow you to do that
> >> >>> > can't be done today?
> >> >>>
> >> >>> There are 2 reasons for this,
> >> >>>
> >> >>> First, our chip supports weather band, unlike other bands (Europe,
> >> >>> Japan and Russian) user may wants to
> >> >>> switch to weather band and wants to listen to weather report and again
> >> >>> switches back to normal band.
> >> >>
> >> >> OK, that makes sense. Are the RX and TX independent with regards to
> >> >> band selection?
> >> >
> >> > Yes - RX and TX are independent of band selection
> >> >
> >> >> Make sure that when the band is changed the rangelow and rangehigh values
> >> >> are also changed. If the current frequency is out of that range, then the
> >> >> frequency should be clamped to the closest value frequency. Although an
> >> >> alternative strategy might be to remember the last used frequency for each
> >> >> band. That might make more sense in the case of switching between a normal
> >> >> band and the weather band. We need to define and document which strategy
> >> >> should be used here.
> >> >
> >> > As of now when I switch to new band I just set the frequency to lowest
> >> > of the new band.
> >> > In this way user can seek and tune to what ever channel he wants.
> >> >
> >> Hans,
> >>
> >> Which implementation you wants? start with the lowest of the new band
> >> or closer to the frequency of old band? do we need to remember the
> >> present frequency of the band before switching to new band?
> >>
> >> Please let me know your views.
> >
> > The initial frequency of each band is driver dependent. That's how drivers
> > act at the moment, so we keep that.
> >
> > When switching bands it is best to keep the frequency closest to the old band.
> > This makes sense when switching from e.g. US/Europe and Japan band where there
> > is overlap in frequencies, so I think that's the best approach.
> >
> >> Since this feature is required by all FM receivers shall I make this
> >> as a generic CID?
> >
> > Yes, but see my next question below.
> >
> >>
> >> >> BTW, is the receiver for the weather band implemented as a separate receiver?
> >> >> I read that some devices can listen to the normal band and interrupt that
> >> >> when a weather report is broadcast on the weather band. That implies two
> >> >> receivers and it would require a rethink.
> >> >>
> >> >> Also, is this feature really implemented as separate frequency ranges in
> >> >> hardware? Or is the receiver able to receive on the whole range of frequencies
> >> >> from 65.8 (OIRT) to approx. 165 (weather band range)?
> >> >
> >> > Our chip wont have 2 receivers, it has only 1 receiver which can
> >> > receive on whole frequency range from 65 MHz to 165 MHz.
> >
> > If that's the case, then what does the band selector control actually have to do
> > hardware-wise? Does it just clamp the frequency to the correct frequency range?
> 
> The Wilink chip can't able to receive on all frequencies at a time,
> instead first we need to set the band(need to set chip registers to do
> so) on which receiver has to receive, after this the chip can receive
> on frequency range of this band only.
> 
> Eg: When set to Europe band chip can only receive from 87.5 MHz to 108
> MHz, in this case receiver will give band limit reached interrupt if
> tried to set frequency other than within this band.
> 
> Band selector controller will first switch the band of reception and
> then sets the frequency which is within that band.
> 
> >
> >> >
> >> >> Is the datasheet of this device available somewhere?
> >> >
> >> > Sorry our newest chipset supports this feature so yet now we don't
> >> > have any datasheet available on net.
> >> >
> >> >>
> >> >>> Second,  for FM TX, our chip supports band selection for FM
> >> >>> transmitter, so if the same phone is used in different
> >> >>> regions of world then user can switch to the actual band and start
> >> >>> transmitting by choosing a blank frequency in that band.
> >> >>
> >> >> Isn't this something that can be equally easily done in userspace?
> >> >
> >> > you wants me to do this from driver itself without hinting the
> >> > application about the band ?
> >
> > I think my question is really the same as above: what does the band selector
> > control actually have to do for a TX hardware-wise?
> 
> Yes TX case I accept we may not need the band switch controller,
> instead when user wants to set a frequency, driver will see in which
> band this frequency comes and then first switches the FM chip to
> transmit in that band and then sets the frequency.
> 
> So I don't add any private or public CID for this.

Good.

> >
> > None of the existing radio RX and TX drivers need a band selector, because
> > they just cover the whole frequency range. If apps want to create these bands,
> > then they can do so themselves. So I am trying to understand why this device
> > needs a band selector. It's why I was interested in the datasheet...
> 
> In RX case the the above provided solution wont work because
> 1) If user do hardware seek then seek will be performed within the
> present band not throughout from 65MHz to 162 MHz
> 2) If user wants to switch band he should know the frequency range of
> the band to which he is switching and then set the frequency within
> that band.
> 
> Hardware seek functionality is one of the main reason why we need band
> switch, most of the time user may not have knowledge about the
> frequency ranges of bands so in that case use will switch to a band
> and do hardware seek, if stations found then he will continue on the
> same band if not he can check the next available band and do seek
> again.

How about this: rather than adding a band selection control, why not add a
new band field to struct v4l2_hw_freq_seek? The default, 0, means just use the
full frequency range. Then define the other bands (these are pretty much
standardized). If a band is not supported by the hardware, -ERANGE is returned.
Otherwise the current frequency is clamped to the specified band frequency range
and you start searching.

Band selection doesn't really make sense outside of hardware seek.

Regards,

	Hans
