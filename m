Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2CGVm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:42:28 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50625 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2CGVm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:42:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAMT6PyfS3vkQu8dZ2qFu=iMo48XL3H=_dU2C4GYxLP-sNYqtqg@mail.gmail.com>
References: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
 <201202291225.50801.hverkuil@xs4all.nl> <CAMT6PyeaW2OwRc5So5JtTeUVJ9vFLafddLteSqoW3GJaVrFesA@mail.gmail.com>
 <201203021022.49464.hverkuil@xs4all.nl> <CAMT6PyfS3vkQu8dZ2qFu=iMo48XL3H=_dU2C4GYxLP-sNYqtqg@mail.gmail.com>
From: halli manjunatha <hallimanju@gmail.com>
Date: Wed, 7 Mar 2012 15:42:05 -0600
Message-ID: <CAMT6PyeYYo1RwwH2vvPYMfKT7ccssifQRbOcXn5ayYAdLdZiKg@mail.gmail.com>
Subject: Re: [PATCH 3/3] wl128x: Add sysfs based support for FM features
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>, shahed@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:24 AM, halli manjunatha <hallimanju@gmail.com> wrote:
> On Fri, Mar 2, 2012 at 3:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Wednesday, February 29, 2012 18:19:27 halli manjunatha wrote:
>>> On Wed, Feb 29, 2012 at 5:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> > On Tuesday, February 28, 2012 23:52:21 halli manjunatha wrote:
>>> >> On Tue, Feb 28, 2012 at 4:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> >> > On Monday, February 27, 2012 17:29:18 halli manjunatha wrote:
>>> >> >> Hi Hans,
>>> >> >>
>>> >> >> Agreed I don't mind to create new controls for below things
>>> >> >>
>>> >> >> 1) FM RX Band selection (US/Europe, Japan and Russian bands)
>>> >> >> 2) FM RX RDS AF turn ON/OFF
>>> >> >> 3) FM RX RSSI level set/get
>>> >> >> 4) FM TX Alternate Frequency set/get
>>> >> >> 5) FM RX De-Emphasis mode set/get
>>> >> >>
>>> >> >> However, previously you have suggested me to hide few controls (like
>>> >> >> band selection) from the user but few of our application wanted
>>> >> >> controls like above and that is why I have created the sysfs entries.
>>> >> >>
>>> >> >> Please suggest me how can I move forward with new controls or with sysfs?
>>> >> >
>>> >> > The first question is which of these controls are general to FM receivers or
>>> >> > transmitters, and which are specific to this chipset. The chipset specific
>>> >> > controls should be private controls (look at V4L2_CID_MPEG_CX2341X_BASE in
>>> >> > videodev2.h how those are defined). The others should be defined as new
>>> >> > controls of the FM_TX class or the FM_RX class. The FM_RX class should be
>>> >> > defined as a new class as it doesn't exist at the moment. Don't forget to
>>> >> > document these controls clearly.
>>> >> >
>>> >> > With regards to the band selection: I remember that there was a discussion,
>>> >> > but not the details. Do you have a link to that discussion? I can't find it
>>> >> > (at least not quickly :-) ).
>>> >>
>>> >> Below features are generic to all FM receivers so we can add new CID's
>>> >> for below features
>>> >> 1) FM RX RDS AF turn ON/OFF
>>> >> 2) FM TX Alternate Frequency set/get
>>> >>
>>> >> About other 3 features its different issue,
>>> >>     1) FM RX Band selection (US/Europe, Japan and Russian bands)
>>> >>     2) FM RX RSSI level set/get
>>> >>     3) FM RX De-Emphasis mode set/get
>>> >>
>>> >> All these 3 features are generic to any FM receiver, only question is
>>> >> does all FM receivers wants to expose these controls to application
>>> >> writer?
>>> >
>>> > Good question, and there is no good answer at the moment. See e.g. this
>>> > IRC discussion:
>>> >
>>> > http://www.spinics.net/lists/linux-media/msg44023.html
>>> >
>>> > In the absence of a good solution to this problem I am inclined to make
>>> > these controls driver specific but marked experimental. The experimental
>>> > tag allows us to eventually make it a generic control without too much
>>> > hassle.
>>>
>>> Agreed, I will make them driver specific and mark them as experimental.
>>>
>>> >
>>> >> Example Band selection, every FM receiver at the minimum supports both
>>> >> Europe and Japan band, now the question is should we add a CID to
>>> >> switch between these two bands?
>>> >
>>> > If we decide to add a band selection control, then that would be a menu
>>> > control (since there are up to three bands) and it would only be implemented
>>> > by drivers that need it.
>>> >
>>> > What I am still not clear on is *why* you would want this control. What
>>> > is the reason your customers want this? What does it allow you to do that
>>> > can't be done today?
>>>
>>> There are 2 reasons for this,
>>>
>>> First, our chip supports weather band, unlike other bands (Europe,
>>> Japan and Russian) user may wants to
>>> switch to weather band and wants to listen to weather report and again
>>> switches back to normal band.
>>
>> OK, that makes sense. Are the RX and TX independent with regards to
>> band selection?
>
> Yes - RX and TX are independent of band selection
>
>> Make sure that when the band is changed the rangelow and rangehigh values
>> are also changed. If the current frequency is out of that range, then the
>> frequency should be clamped to the closest value frequency. Although an
>> alternative strategy might be to remember the last used frequency for each
>> band. That might make more sense in the case of switching between a normal
>> band and the weather band. We need to define and document which strategy
>> should be used here.
>
> As of now when I switch to new band I just set the frequency to lowest
> of the new band.
> In this way user can seek and tune to what ever channel he wants.
>
Hans,

Which implementation you wants? start with the lowest of the new band
or closer to the frequency of old band? do we need to remember the
present frequency of the band before switching to new band?

Please let me know your views.

Since this feature is required by all FM receivers shall I make this
as a generic CID?

>> BTW, is the receiver for the weather band implemented as a separate receiver?
>> I read that some devices can listen to the normal band and interrupt that
>> when a weather report is broadcast on the weather band. That implies two
>> receivers and it would require a rethink.
>>
>> Also, is this feature really implemented as separate frequency ranges in
>> hardware? Or is the receiver able to receive on the whole range of frequencies
>> from 65.8 (OIRT) to approx. 165 (weather band range)?
>
> Our chip wont have 2 receivers, it has only 1 receiver which can
> receive on whole frequency range from 65 MHz to 165 MHz.
>
>> Is the datasheet of this device available somewhere?
>
> Sorry our newest chipset supports this feature so yet now we don't
> have any datasheet available on net.
>
>>
>>> Second,  for FM TX, our chip supports band selection for FM
>>> transmitter, so if the same phone is used in different
>>> regions of world then user can switch to the actual band and start
>>> transmitting by choosing a blank frequency in that band.
>>
>> Isn't this something that can be equally easily done in userspace?
>
> you wants me to do this from driver itself without hinting the
> application about the band ?
>
>>
>> Regards,
>>
>>        Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Regards
> Halli



-- 
Regards
Halli
