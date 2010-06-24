Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0FXIIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:08:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60317 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0FXIIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RCWxpwSCZLyvKME+ZGWGdX7xrcqr5kuUCK4ylijJihUhC1RXyT4U1v7wzO8WuquCl/
         nWYMqGawIsPANhMTMWPySjcjs+JcONTGLAhzgO9aTGYyLq8z6hOqfBqAe55m7dRjZNsd
         0LupnpYL3kyJjJH4t/fvyz0VM6UUXyRbOeKU8=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <1277325732.2521.55.camel@lap75545.ornl.gov>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org> <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com> 
	<AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com> 
	<AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com> 
	<1277262047.10818.9.camel@obelisk.thedillows.org> <1277271419.10818.22.camel@obelisk.thedillows.org> 
	<AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com> 
	<1277325732.2521.55.camel@lap75545.ornl.gov>
From: Hans Schou <linux@schou.dk>
Date: Thu, 24 Jun 2010 10:08:17 +0200
X-Google-Sender-Auth: REqdIpXWM-k0KEW-4vLgsHUUjsk
Message-ID: <AANLkTinlo1B3LtdMuxOYwU8hhcYV69g0JeODfdTVy6if@mail.gmail.com>
Subject: Re: [alsa-devel] PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/23 David Dillow <dave@thedillows.org>:
> On Wed, 2010-06-23 at 20:22 +0200, Hans Schou wrote:

>>    int fd = open("/dev/dsp",  O_RDWR);
>>
>> This should not go through ALSA (I think). I gues one should use
>> something with "snd_pcm_open()" to use ALSA.
>
> To use ALSA directly, yes. However, there is no OSS SIS7019 driver in
> the kernel, only the ALSA one I wrote. There is an OSS emulation layer,
> so you can use the OSS API to talk to the ALSA core. Unless you are
> using a vendor (SIS/MicroJr/etc.) supplied driver, you are using ALSA in
> some capacity.

OK. Thanks for clearing it out.

I guess I should have programmed against ALSA when I started.

>> I really don't understand why I do not see this problem on other
>> hardware using the same compiled code.
>
> You mean the 10 second pauses during recording after 42 minutes? That is
> a driver bug, so it is specific to this card.

OK. And 42 min is also the only problem I see. I have no problems with
the recorded sounds.

> If you mean the alternating long/sort period times, then it is present
> on other hardware, but you likely don't see it either due to the
> defaults giving you more periods to work in so you don't see overruns,
> faster hardware than the SIS550 CPU, or a combination of the two. The
> bug that gives rise to the 10 second pauses can also shorten the periods
> I think, making overruns more likely to occur.

OK.

/hans
