Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2EGOxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:53:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60892 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2EGOxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <201205062100.09979.hverkuil@xs4all.nl>
References: <1336164542-11014-1-git-send-email-manjunatha_halli@ti.com>
 <1336164542-11014-5-git-send-email-manjunatha_halli@ti.com>
 <201205050041.34232.hverkuil@xs4all.nl> <201205062100.09979.hverkuil@xs4all.nl>
From: halli manjunatha <hallimanju@gmail.com>
Date: Mon, 7 May 2012 09:52:47 -0500
Message-ID: <CAMT6PydcZmSj6xM0j8YgxECWPiunhkqg2Zb+hPNweUeiBt_rXQ@mail.gmail.com>
Subject: Re: [PATCH V4 4/5] Media: Update docs for V4L2 FM new features
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 2:00 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sat May 5 2012 00:41:34 Hans Verkuil wrote:
>> > +    <table pgwide="1" frame="none" id="Radio band Types">
>> > +      <title>Radio Band Types</title>
>> > +      <tgroup cols="2">
>> > +   &cs-str;
>> > +   <tbody valign="top">
>> > +               <row>
>> > +                 <entry><constant>FM_BAND_TYPE_ALL</constant>&nbsp;</entry>
>> > +                 <entry>All Bands from 65.8 MHz till 108 Mhz or 162.55 MHz if weather band.</entry>
>> > +               </row>
>>
>> Hmm, I have to thing about that name. And about other related issues as well:
>> what to do if a band isn't supported? How does an application know which bands are
>> in fact supported?
>>
>> It's too late and I'll have to think about this tomorrow.
>
> OK, I've thought about this a bit more. First of all we need a way to detect
> which bands are supported. I propose to add capability flags to struct v4l2_tuner,
> one for each band. There are more than enough capability flags available, so we can
> start from bit 16 and add 4 capability flags for the four bands.
>
> Since applications can now detect which bands are available, it is OK for the SEEK
> ioctl to return -EINVAL if the band isn't present. Please update the SEEK ioctl
> documentation accordingly.
>
> With respect to the name FM_BAND_TYPE_ALL: I propose to rename that to _TYPE_DEFAULT.
> The description should be something like:
>
> "This is the default band, which should be the widest frequency range supported by
> the hardware."
>
> I think that is a better name since that is what drivers to at the moment. I don't
> think you can guarantee an 'All bands' setting as that is often limited by the hardware.
>
> What do you think?
Looks good to me... I will submit the next version of patch set with
all these suggestion :)
>
> Regards,
>
>        Hans
>
>>
>> Regards,
>>
>>       Hans
>>
>> > +               <row>
>> > +                 <entry><constant>FM_BAND_TYPE_EUROPE_US</constant>&nbsp;</entry>
>> > +                 <entry>Europe or US band(87.5 Mhz - 108 MHz).</entry>
>> > +               </row>
>> > +               <row>
>> > +                 <entry><constant>FM_BAND_TYPE_JAPAN</constant>&nbsp;</entry>
>> > +                 <entry>Japan band(76 MHz - 90 MHz).</entry>
>> > +               </row>
>> > +               <row>
>> > +                 <entry><constant>FM_BAND_TYPE_RUSSIAN</constant>&nbsp;</entry>
>> > +                 <entry>OIRT or Russian band(65.8 MHz - 74 MHz).</entry>
>> > +               </row>
>> > +               <row>
>> > +                 <entry><constant>FM_BAND_TYPE_WEATHER</constant>&nbsp;</entry>
>> > +                 <entry>Weather band(162.4 MHz - 162.55 MHz).</entry>
>> > +               </row>
>> > +   </tbody>
>> > +      </tgroup>
>> > +    </table>
>> >
>> >    <refsect1>
>> >      &return-value;
>> >
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards
Halli
