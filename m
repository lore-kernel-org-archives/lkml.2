Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2JNRX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 13:23:56 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59575 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab2JNRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 13:23:55 -0400
Date: Sun, 14 Oct 2012 19:22:53 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121014192253.5a7517ef@neptune.home>
In-Reply-To: <507AEE4A.1000907@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<20121014104138.7e8a9c59@neptune.home>
	<507A997D.7070508@cfl.rr.com>
	<20121014130323.06f0225d@neptune.home>
	<507AEE4A.1000907@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> I've taken the EDID data from that service manual. I've looked at the 
> EDID-Howto for how to specify the connector but all I see is:
> 
> "An EDID data set will only be used for a particular connector,
>   if its name and a colon are prepended to the EDID name."
> 
> Where can I find the connector names?

Those are the ones you see under /sys/class/drm/, without the card0-
prefix.

E.g. on my system I have:

# ls /sys/class/drm/
card0  card0-DVI-I-1  card0-LVDS-1  card0-VGA-1  controlD64  version

Thus I have connectors "DVI-I-1", "LVDS-1" and "VGA-1" (note that your
HDMI connector might not be named HDMI-1, if you are not sure which one
it is, you can look at the files below (edid, enabled, status) which
should help your find the right connector).


In addition, if you rmmod i915 and modprobe it again connectors will get
increased suffix numbers. So don't expect them to remain the same if you
have multiple GPUs detected in random order or if you rebind them to
their driver. (though except during testing or for special systems you
don't have to worry about this)

> And could I ask if this simple pgm might work to build the file I need?

It looks fine. You can also check the output with hexdump just to
make sure it looks sane.
If it's broken kernel will tell you that checksum does not match.

In any case the (successful) loading of edid should be visible in kernel
log.


Bruno


> int32_t main(int argc, char **argv)
> {
>          FILE *fd;
>          const char *path = "/lib/firmware/edid/lg42lb9df.edid";
>          const char *mode = "w+";
>          uint8_t firmware[1024] = {
> 
>                  0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x1E, 
> 0x6D, 0x01, 0x00, 0x01, 0x01, 0x01, 0x01,
>                  0x0E, 0x10, 0x01, 0x03, 0x80, 0x73, 0x41, 0x96, 0x0A, 
> 0xCF, 0x74, 0xA3, 0x57, 0x4C, 0xB0, 0x23,
>                  0x09, 0x48, 0x4C, 0xAF, 0xCF, 0x00, 0x31, 0x40, 0x45, 
> 0x40, 0x61, 0x40, 0x81, 0x80, 0xA9, 0x40,
>                  0xD1, 0xC0, 0x01, 0x01, 0x01, 0x01, 0x02, 0x3A, 0x80, 
> 0x18, 0x71, 0x38, 0x2D, 0x40, 0x58, 0x2C,
>                  0x45, 0x00, 0xC4, 0x8E, 0x21, 0x00, 0x00, 0x1E, 0x66, 
> 0x21, 0x50, 0xB0, 0x51, 0x00, 0x1B, 0x30,
>                  0x40, 0x70, 0x36, 0x00, 0xC4, 0x8E, 0x21, 0x00, 0x00, 
> 0x1E, 0x00, 0x00, 0x00, 0xFD, 0x00, 0x38,
>                  0x4B, 0x1F, 0x44, 0x0F, 0x00, 0x0A, 0x20, 0x20, 0x20, 
> 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xFC,
>                  0x00, 0x4C, 0x47, 0x20, 0x54, 0x56, 0x0A, 0x20, 0x20, 
> 0x20, 0x20, 0x20, 0x20, 0x20, 0x01, 0x15,
> 
>                  0x02, 0x03, 0x1B, 0xF1, 0x4C, 0x20, 0x22, 0x10, 0x1F, 
> 0x01, 0x02, 0x03, 0x04, 0x05, 0x12, 0x93,
>                  0x14, 0x23, 0x15, 0x07, 0x50, 0x65, 0x03, 0x0C, 0x00, 
> 0x10, 0x00, 0x01, 0x1D, 0x00, 0x72, 0x51,
>                  0xD0, 0x1E, 0x20, 0x6E, 0x28, 0x55, 0x00, 0xC4, 0x8E, 
> 0x21, 0x00, 0x00, 0x1E, 0x01, 0x1D, 0x80,
>                  0x18, 0x71, 0x1C, 0x16, 0x20, 0x58, 0x2C, 0x25, 0x00, 
> 0xC4, 0x8E, 0x21, 0x00, 0x00, 0x9E, 0x8C,
>                  0x0A, 0xD0, 0x90, 0x20, 0x40, 0x31, 0x20, 0x0C, 0x40, 
> 0x55, 0x00, 0x4C, 0x6C, 0x42, 0x00, 0x00,
>                  0x18, 0x01, 0x1D, 0x00, 0xBC, 0x52, 0xD0, 0x1E, 0x20, 
> 0xB8, 0x28, 0x55, 0x40, 0x4C, 0x6C, 0x42,
>                  0x00, 0x00, 0x1E, 0x01, 0x1D, 0x80, 0xD0, 0x72, 0x1C, 
> 0x16, 0x20, 0x10, 0x2C, 0x25, 0x80, 0x4C,
>                  0x6C, 0x42, 0x00, 0x00, 0x9E, 0x00, 0x00, 0x00, 0x00, 
> 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xED
>          };
> 
>          fd = fopen(path, mode);
>          if (fd == NULL) {
>                  perror("/lib/firmware/edid/lg42lb9df.edid failed: ");
>                  return 1;
>          }
> 
>          fwrite(&firmware, 1024, 1, fd);
> 
>          fclose(fd);
> 
>          printf("Wrote 1024 bytes of edid data to %s\n", path);
> 
>          return 0;
> }
> 
> Thanks very much
> Mark

