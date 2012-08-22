Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab2HVTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:08:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54218 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2HVTIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-2-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-2-git-send-email-cheiny@synaptics.com>
Date: Wed, 22 Aug 2012 21:08:00 +0200
Message-ID: <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/17] input: RMI4 public header file and documentation.
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
<cheiny@synaptics.com> wrote:

(...)
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +#include <linux/earlysuspend.h>
> +#endif

This does not exist in the mainline kernel, I can see you're having fun with
Android ... check with Rafael on how to really handle this in a contemporary
kernel.

> +/**
> + * struct rmi_f11_axis_alignment - target axis alignment
> + * @swap_axes: set to TRUE if desired to swap x- and y-axis
> + * @flip_x: set to TRUE if desired to flip direction on x-axis
> + * @flip_y: set to TRUE if desired to flip direction on y-axis

This kerneldoc is quite incomplete. There is a *lot* of members below
that are not documented.

> + */
> +struct rmi_f11_2d_axis_alignment {
> +       bool swap_axes;
> +       bool flip_x;
> +       bool flip_y;
> +       int clip_X_low;
> +       int clip_Y_low;
> +       int clip_X_high;
> +       int clip_Y_high;
> +       int offset_X;
> +       int offset_Y;
> +       int rel_report_enabled;
> +
> +#ifdef CONFIG_RMI4_DEBUG
> +       struct dentry *debugfs_flip;
> +       struct dentry *debugfs_clip;
> +       struct dentry *debugfs_offset;
> +       struct dentry *debugfs_swap;
> +       u16 reg_debug_addr;
> +       u8 reg_debug_size;
> +#endif
> +};

(...)
> +struct rmi_f11_virtualbutton_map {
> +       u8 buttons;
> +       struct virtualbutton_map *map;
> +};

<newline> (nitpick)

> +struct rmi_device_platform_data_spi {
> +       int block_delay_us;
> +       int split_read_block_delay_us;
> +       int read_delay_us;
> +       int write_delay_us;
> +       int split_read_byte_delay_us;
> +       int pre_delay_us;
> +       int post_delay_us;
> +
> +       void *cs_assert_data;
> +       int (*cs_assert) (const void *cs_assert_data, const bool assert);
> +};
> +
> +/**
> + * struct rmi_device_platform_data - system specific configuration info.
> + *
> + * @firmware_name - if specified will override default firmware name,
> + * for reflashing.
> + *
> + * @f11_type_b - Force F11 to treat the sensor as a multitouch Type B sensor.
> + * This is useful for older Type B RMI4 sensors that can't be queried for this
> + * information, but will cause problems if you force a Type A sensor to be
> + * treated as type_b.
> + *
> + * @pre_suspend - this will be called before any other suspend operations are
> + * done.
> + * @post_suspend - this will be called after all suspend operations are
> + * completed.  This is the ONLY safe place to power off an RMI sensor
> + * during the suspend process.
> + * @pre_resume - this is called before any other resume operations.  If you
> + * powered off the RMI4 sensor in post_suspend(), then you MUST power it back
> + * here, and you MUST wait an appropriate time for the ASIC to come up
> + * (100ms to 200ms, depending on the sensor) before returning.
> + * @pm_data - this will be passed to the various (pre|post)_(suspend/resume)
> + * functions.

This kerneldoc is incomplete, maybe intentional, I don't know...

(...)
> +struct rmi_function_handler {
> +       int func;
> +       int (*init)(struct rmi_function_container *fc);
> +       int (*config)(struct rmi_function_container *fc);
> +       int (*reset)(struct rmi_function_container *fc);
> +       int (*attention)(struct rmi_function_container *fc, u8 *irq_bits);
> +#ifdef CONFIG_PM
> +       int (*suspend)(struct rmi_function_container *fc);
> +       int (*resume)(struct rmi_function_container *fc);
> +#if defined(CONFIG_HAS_EARLYSUSPEND) && \
> +               !defined(CONFIG_RMI4_SPECIAL_EARLYSUSPEND)

There is this earlysuspend again, now with some turbo-version
which is "special" as well :-)

> +       int (*early_suspend)(struct rmi_function_container *fc);
> +       int (*late_resume)(struct rmi_function_container *fc);
> +#endif
> +#endif
> +       void (*remove)(struct rmi_function_container *fc);
> +};

(...)
> +/**
> + * struct rmi_device - represents an RMI device
> + * @dev: The device created for the RMI bus
> + * @number: Unique number for the device on the bus.
> + * @driver: Pointer to associated driver
> + * @phys: Pointer to the physical interface
> + * @early_suspend_handler: Pointers to early_suspend and late_resume, if
> + * configured.
> + *
> + * This structs represent an RMI device.
> + *
> + */
> +struct rmi_device {
> +       struct device dev;
> +       int number;
> +
> +       struct rmi_driver *driver;
> +       struct rmi_phys_device *phys;
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +       struct early_suspend early_suspend_handler;
> +#endif

...and here...

> +#ifdef CONFIG_RMI4_DEBUG
> +       struct dentry *debugfs_root;
> +#endif
> +};

(...)
> +/* Helper fn to convert a byte array representing a short in the RMI
> + * endian-ness to a short in the native processor's specific endianness.
> + * We don't use ntohs/htons here because, well, we're not dealing with
> + * a pair of shorts. And casting dest to short* wouldn't work, because
> + * that would imply knowing the byte order of short in the first place.
> + */
> +static inline void batohs(unsigned short *dest, unsigned char *src)

Change this prototype to use kernel-internal types, and what is
wron with using the return value??

static inline void batohs(unsigned short *dest, unsigned char *src)

> +{
> +       *dest = src[1] * 0x100 + src[0];
> +}

Doing this instead of casting is good style. But I would have done like this:

static inline u16 batohs(u8 *src)
{
   return src[1] << 8 | src[0];
}

Which the compiler *hopufully will emit, but since we're doing
arithmetic, not maths, please use shifts and OR:s.

And at the call sites, instead of

unsigned short mr16;
unsigned char mr_arrary[2];
batohs(&mr16, &mr_array[0]);

Just:

u16 mr16;
u8 mr_array[2];

mr16 = batohs(&mr_array[0]);

> +/* Helper function to convert a short (in host processor endianess) to
> + * a byte array in the RMI endianess for shorts.  See above comment for
> + * why we dont us htons or something like that.
> + */
> +static inline void hstoba(unsigned char *dest, unsigned short src)

Here yuou need to pass a pointer to the destination for sure.

> +{
> +       dest[0] = src % 0x100;
> +       dest[1] = src / 0x100;
> +}

I would have done the above like this:

static inline void hstoba(u8 *dest, u16 src)
{
  dest[0] = src & 0xFF;
  dest[1] = src >> 8;
}

(...)
> +/* utility function for bit access of u8*'s */

No, do not reinvent the wheel. Use
#include <linux/bitmap.h>
(which in turn will include <linux/bitops.h> for you)
Those bitmaps use unsigned int but that does not
really matter, they should work just fine using the lower
8 bits.

> +void u8_set_bit(u8 *target, int pos);

Use set_bit() from <linux/bitops.h>

> +void u8_clear_bit(u8 *target, int pos);

Use clear_bit() from <linux/bitops.h>

> +bool u8_is_set(u8 *target, int pos);

Use test_bit() from <linux/bitops.h>

> +bool u8_is_any_set(u8 *target, int size);

Use find_first_bit(), if this returns 0 none is set, !find_first_bit() for
example serves the same purpose.

> +void u8_or(u8 *dest, u8* target1, u8* target2, int size);

Use bitmap_or()

> +void u8_and(u8 *dest, u8* target1, u8* target2, int size);

Use bitmap_and()

Yours,
Linus Walleij
