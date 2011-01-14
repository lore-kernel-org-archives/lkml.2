Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1ANSW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:22:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58179 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab1ANSWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AWifrcCVHepLIEOQyXVrbeQVGp+cYmry6FT+T+E/8isE5bLUPcLijo4T+emyweN/Pc
         oekIQfe+kVg+SmxaGLANZtSGgrWVValAm0oA49+QgVWVM1zYUmQi0eiquLsgZHwQ5Q3j
         D8SPNGpogVG8c0I4DU1mNxhTmJKXRFME38ohQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101141633200.5594@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<4D2CE5C8.60601@de.ibm.com>
	<AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
	<4D2D8ED0.6080807@de.ibm.com>
	<AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
	<alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
	<AANLkTimdnYHWfBE1nB+2EDRouO7_FoRByVboMYw8WaHB@mail.gmail.com>
	<AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com>
	<alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
	<alpine.LFD.2.00.1101131752190.311@casper.infradead.org>
	<AANLkTimdPFGJxjWHPZ2kojxJoj76zDw2=fiwDiMrinjy@mail.gmail.com>
	<alpine.LFD.2.00.1101141633200.5594@casper.infradead.org>
Date: Fri, 14 Jan 2011 20:22:45 +0200
Message-ID: <AANLkTimkP48aPmUwi86EPA+KPODUv=4P1BAuMqb=Hx9Q@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 6:38 PM, James Simmons <jsimmons@infradead.org> wrote:
>
> On Thu, 13 Jan 2011, Anca Emanuel wrote:
>
>> On Thu, Jan 13, 2011 at 7:55 PM, James Simmons <jsimmons@infradead.org> wrote:
>> >
>> >> > > With your patch, I can boot the system. But nouveau is not loaded.
>> >> > > dmesg attached.
>> >> > >
>> >> >
>> >> > Forget to mention: the revert makes first steps of boot look the same
>> >> > (change the resolution of the text)
>> >> > but with your patch, I see a big ugly ununtu logo, (I think that is
>> >> > because nouveau is not loaded)
>> >
>> > Okay, can you do one more experiment for me. Since you already reverted
>> > the patch to get it booting I like to ask you to add
>> >
>> > drm_fb_helper_fill_fix(info, fb_helper->fb);
>> >
>> > back into the drm_fb_helper_set_par function in drm_fb_helper.c. You have
>> > something like this:
>> >
>> >        mutex_lock(&dev->mode_config.mutex);
>> >        for (i = 0; i < fb_helper->crtc_count; i++) {
>> >                crtc = fb_helper->crtc_info[i].mode_set.crtc;
>> >                ret = crtc->funcs->set_config(&fb_helper->crtc_info[i].mode_set);
>> >                if (ret) {
>> >                        mutex_unlock(&dev->mode_config.mutex);
>> >                        return ret;
>> >                }
>> >                drm_fb_helper_fill_fix(info, fb_helper->fb);
>> >        }
>> >        mutex_unlock(&dev->mode_config.mutex);
>> >
>> > Tell me if your system is still usable after that. Thanks for testing for
>> > me.
>> >
>>
>> after
>>
>> git revert dfe63bb0ad9810db13aab0058caba97866e0a681
>>
>> and
>>
>>
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
>> index 5c4f9b9..2aad663 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -816,6 +816,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
>>                         mutex_unlock(&dev->mode_config.mutex);
>>                         return ret;
>>                 }
>> +               drm_fb_helper_fill_fix(info, fb_helper->fb->pitch, fb_helper->fb
>>         }
>>         mutex_unlock(&dev->mode_config.mutex);
>>
>> I get an working system. ( the boot screen is not ok )
>> Tested suspend/resume. Dmesg attached.
>
> Just as I thought. Even this breaks the nouveau driver.
>
> Could you now add also in the drm_fb_helper_fill_fix function
>
> DRM_INFO("pitch %d, depth %d\n", fb_helper->fb->pitch,
>          fb_helper->fb->depth);
>
> I have a feeling the values are not right. Thanks.
>

Please make an patch to test.
