Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1BYHSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:18:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40630 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1BYHSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QksZQYHfsjOlkA9lPcfIp10ovm5fOm010zkQOma3Sp8cDTDX5g0aK2p+qSQXfqGXhv
         lNTMIidJPQG/QzoGDBBdsvfXYNSz+B2rTkD+DSUWj7gfkvR1rnOU8dUl02eLUSzUJ0L+
         QaQz4UVjO7nyR7g6KJ4At5kh7vSyQUDoRtUYc=
Date: Thu, 24 Feb 2011 23:18:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
Message-ID: <20110225071827.GA14053@core.coreip.homeip.net>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
 <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 07:52:11AM +0100, Corentin Chary wrote:
> On Fri, Feb 25, 2011 at 6:19 AM, Keng-Yu Lin <keng-yu.lin@canonical.com> wrote:
> > Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
> > ---
> >  drivers/platform/x86/eeepc-wmi.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > https://bugs.freedesktop.org/show_bug.cgi?id=31333
> >
> > diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> > index d399775..da00cbc 100644
> > --- a/drivers/platform/x86/eeepc-wmi.c
> > +++ b/drivers/platform/x86/eeepc-wmi.c
> > @@ -113,7 +113,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
> >        { KE_KEY, 0x32, { KEY_MUTE } },
> >        { KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
> >        { KE_KEY, 0x5d, { KEY_WLAN } },
> > -       { KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
> > +       { KE_KEY, 0x6b, { KEY_F21 } }, /* Disable Touchpad */
> >        { KE_KEY, 0x82, { KEY_CAMERA } },
> >        { KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
> >        { KE_KEY, 0x88, { KEY_WLAN } },
> 
> Hum, I'm not very comfortable with this patch now that we got
> KEY_TOUCHPAD_TOGGLE.
> I know, it doesn't work with current Xorg, but if we continue to
> workaround that, it'll never be fixed.
> 
> Dmitry, Matthew, any advice ?

I believe that the kernel should use KEY_TOUCHPAD_TOGGLE and userspace
should use udev's key re-mapping facilities while X is unable to process
keycodes above 255 to adjust to the keycode du jour. If all kernel
drivers were to use KEY_TOUCHPAD_TOGGLE then remapping would be much
easier (the utility would simply check capabilities for
KEY_TOUCHPAD_TOGGLE and do the remap).

Thanks.

-- 
Dmitry
