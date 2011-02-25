Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1BYPOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:14:09 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36712 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1BYPOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <20110225071827.GA14053@core.coreip.homeip.net>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
	<AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
	<20110225071827.GA14053@core.coreip.homeip.net>
Date: Fri, 25 Feb 2011 09:14:06 -0600
Message-ID: <AANLkTinV+bnSBe+5CSuYYCU4gCq9Z2c9ELdy-LFAvdf0@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
From: Chris Bagwell <chris@cnpbagwell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 1:18 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Feb 25, 2011 at 07:52:11AM +0100, Corentin Chary wrote:
>> On Fri, Feb 25, 2011 at 6:19 AM, Keng-Yu Lin <keng-yu.lin@canonical.com> wrote:
>> > Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
>> > ---
>> >  drivers/platform/x86/eeepc-wmi.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > https://bugs.freedesktop.org/show_bug.cgi?id=31333
>> >
>> > diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
>> > index d399775..da00cbc 100644
>> > --- a/drivers/platform/x86/eeepc-wmi.c
>> > +++ b/drivers/platform/x86/eeepc-wmi.c
>> > @@ -113,7 +113,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>> >        { KE_KEY, 0x32, { KEY_MUTE } },
>> >        { KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
>> >        { KE_KEY, 0x5d, { KEY_WLAN } },
>> > -       { KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
>> > +       { KE_KEY, 0x6b, { KEY_F21 } }, /* Disable Touchpad */
>> >        { KE_KEY, 0x82, { KEY_CAMERA } },
>> >        { KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
>> >        { KE_KEY, 0x88, { KEY_WLAN } },
>>
>> Hum, I'm not very comfortable with this patch now that we got
>> KEY_TOUCHPAD_TOGGLE.
>> I know, it doesn't work with current Xorg, but if we continue to
>> workaround that, it'll never be fixed.
>>
>> Dmitry, Matthew, any advice ?
>
> I believe that the kernel should use KEY_TOUCHPAD_TOGGLE and userspace
> should use udev's key re-mapping facilities while X is unable to process
> keycodes above 255 to adjust to the keycode du jour. If all kernel
> drivers were to use KEY_TOUCHPAD_TOGGLE then remapping would be much
> easier (the utility would simply check capabilities for
> KEY_TOUCHPAD_TOGGLE and do the remap).

I submitted last month a patch to udev to do the scancode-to-F21
mapping.  So that part should be covered for near term.

I also agree if we are going to change kernel side, we should change
to KEY_TOUCHPAD_TOGGLE in both eeepc-laptop and eeepc-wmi.

http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=0d8b6be5f5238360d2d8e220d6da280f842c5358

Chris
