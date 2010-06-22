Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0FVTAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:00:44 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:48638 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0FVTAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:00:42 -0400
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 15:00:41 EDT
Message-ID: <d1cda632f4cdb650a68119903473fbb4.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LNX.2.00.1006211442350.13809@pobox.suse.cz>
References: <alpine.LNX.2.00.1006211442350.13809@pobox.suse.cz>
Date: Tue, 22 Jun 2010 12:34:09 -0600
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Marek Vasut" <marek.vasut@gmail.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, bonbons@linux-vserver.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jiri Kosina wrote:
> On Sat, 19 Jun 2010, Marek Vasut wrote:
>
>> > > >> +/*
>> > > >> + * This is a default logo to be loaded upon driver
>> initialization
>> > > >> + * replacing the default Logitech G13 image loaded on device
>> > > >> + * initialization. This is to provide the user a cue that the
>> > > >> + * Linux driver is loaded and ready.
>> > > >> + *
>> > > >> + * This logo contains the text G13 in the center with two
>> penguins
>> > > >> + * on each side of the text. The penguins are a 33x40 rendition
>> of
>> > > >> + * the default framebuffer 80x80 monochrome image scaled down
>> and
>> > > >> + * cleaned up to retain something that looks a little better
>> than
>> > > >> + * a simple scaling.
>> > > >> + *
>> > > >> + * This logo is a simple xbm image created in GIMP and exported.
>> > > >> + * To view the image copy the following two #defines plus the
>> > > >> + * g13_lcd_bits to an ASCII text file and save with extension
>> > > >> + * .xbm, then open with GIMP or any other graphical editor
>> > > >> + * such as eog that recognizes the .xbm format.
>> > > >> + */
>> > > >
>> > > > ...
>> > > >
>> > > >> +static unsigned char g13_lcd_bits[] = {
>> > > >> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> 0x00,
>> > > >> 0x00,
>> > > >
>> > > > I think you'll agree above is not an elegant solution.
>> > >
>> > > I could make it a config option.
>> >
>> > You get about 10 complains already, but you are not willing to solve
>> > it. No, config option does not help.
>> >
>> > If you want to, make it separate patch so we can reject it separately.
>> >
>> > > >> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
>> > > >
>> > > > Reading above code, it looks like this new userspace sysfs
>> attribute
>> > > > is for backlight control. Could that be better exposed using the
>> > > > existing backlight class?
>> > >
>> > > I looked at the backlight class and it didn't seem to be a very good
>> fit.
>> > >
>> > > /* This structure defines all the properties of a backlight */
>> > > struct backlight_properties {
>> > >
>> > > 	/* Current User requested brightness (0 - max_brightness) */
>> > > 	int brightness;
>> > > 	/* Maximal value for brightness (read-only) */
>> > > 	int max_brightness;
>> > > 	/* Current FB Power mode (0: full on, 1..3: power saving
>> > >
>> > > 	   modes; 4: full off), see FB_BLANK_XXX */
>> > >
>> > > 	int power;
>> > > 	/* FB Blanking active? (values as for power) */
>> > > 	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
>> > > 	int fb_blank;
>> > > 	/* Flags used to signal drivers of state changes */
>> > > 	/* Upper 4 bits are reserved for driver internal use */
>> > > 	unsigned int state;
>> > >
>> > > };
>> > >
>> > > The g13's backlight doesn't support any of these properties. All you
>> can
>> > > set is an rgb value on the g13; no power modes, no brightness, etc.
>> I
>> > > could add a brightness attribute by scaling the rgb values, but I
>> would
>> > > prefer to do that from userspace rather than the driver since it's
>> not
>> > > supported in the device itself.
>> > >
>> > > And, we'd still have to have the rgb attribute since the backlight
>> class
>> > > doesn't have color.
>> >
>> > Or you could pretend you have 3 different backlights? ....which is
>> > actually what you have...?
>> > 									Pavel
>>
>> Any updates on this?
>>
>> btw. it'd be good if we could use the g13fb on G15 ... would that be
>> possible?
>> Cheers!
>
> Rick, please correct me if I am wrong, but as far as I remember, you have
> gathered quite some feedback and were about to incorporate them and
> re-submit the driver, which hasn't happened yet. Is that correct? Or have
> I lost track completely?
>

I've been waiting to resubmit until I get some of the userspace libraries
and utilities a little more mature. There were some things I was exposing
to sysfs that I didn't absolutely need, and some others that I needed to
add.

The cairo and papyrus libraries are (preliminarily) fully working. Once I
make sure I have everything the daemon will need I'll resubmit the driver,
and once that is done I was planning on submitting the libs/utils to
Fedora.

For now, I've been dropping Fedora 12/13 patches and kernel SRPMS here:
http://miskatonic.cs.nmsu.edu/g13/

And the userspace libraries/utilities are at:
http://g13.sourceforge.net

As for the g13fb on the G15... I would imagine it could be done, but I
don't have a G15 so I can't say for sure.

If I had to guess I think you'll have to take the core functionality of
the keyboard driver and extend it with the fb code in the _same_ driver if
the keyboard and display use a similar design to the G13.

The G13 uses the same endpoint for both keyboard input and display
messages, and since a USB endpoint can't be shared across drivers both
will have to reside in the same driver.

--

Rick

