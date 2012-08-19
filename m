Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2HSFsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 01:48:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51625 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2HSFsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 01:48:12 -0400
Message-ID: <1345355288.4887.40.camel@ayu>
Subject: Re: Patch: Thermostat doesn't cool Harddrives (12 inch Powerbooks,
 Ibooks G4)
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Thomas Haschka <haschka@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 19 Aug 2012 01:48:08 -0400
In-Reply-To: <20120818115718.7cbfb18f@astronef.home>
References: <20120818115718.7cbfb18f@astronef.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 11:57 +0200, Thomas Haschka wrote:
> Hello everybody!

Hi Thomas,
Unfortunately, there are quite a few things wrong with your patch that
will likely prevent any kernel developers from picking it up as-is.
Please read through the file Documentation/SubmittingPatches, it has a
lot of helpful hints.

I've added a few more comments inline...

> It was quite hot here in Austria in the recent days and I found out
> that the fan in my 12 inch powerbook only kicked in on CPU, GPU usage,
> while on Mac OS X sides the fan ran nearly all the time (hot as it
> was)... 
> 
> I looked into the therm_adt746 driver and found out that the
> temperature sensor at the harddrive's bottom in the powerbook was not
> taken into account, but it should as one of the air inlets is just
> besides the harddrive, and it is thus also cooled by the fan, ( on can
> verfy that by spinning up the fans an reading out the hdd temp ) .. 
> 
> I created a patch to fix the situation, and I guess that it is pretty
> urgent as I imagine lot's of powerbooks running with their disk
> uncooled.. 
> 
> Here goes the patch
> 
> Thanks for making it accessible.. 
> 
> Thomas

You're missing the Signed-off-by line here. (It's described in the
SubmittingPatches file). Your patch description is pretty good - it
explains clearly why someone would want the patch.

> diff -uprN linux/drivers/macintosh/therm_adt746x.c
> linux-mod/drivers/macintosh/therm_adt746x.c ---
> linux/drivers/macintosh/therm_adt746x.c	2012-08-10
> 12:42:38.000000000 +0200 +++
> linux-mod/drivers/macintosh/therm_adt746x.c	2012-08-18
> 11:29:41.000000000 +0200 @@ -2,6 +2,7 @@

This patch has been word-wrapped and mangled by your email client, and
cannot be applied. The file Documentation/email-clients.txt in the
kernel source has some hints on how to set up your email client to avoid
this problem. (If you're using the Gmail web interface for this, you'll
have to use another client: the Gmail web interface cannot be fixed.)
 
> -static u8 TEMP_REG[3]    = {0x26, 0x25, 0x27}; /* local, sensor1,
> sensor2 */ -static u8 LIMIT_REG[3]   = {0x6b, 0x6a, 0x6c}; /* local,
> sensor1, sensor2 */ -static u8 MANUAL_MODE[2] = {0x5c, 0x5d};       
> -static u8 REM_CONTROL[2] = {0x00, 0x40};
> -static u8 FAN_SPEED[2]   = {0x28, 0x2a};
> -static u8 FAN_SPD_SET[2] = {0x30, 0x31};
> -
> -static u8 default_limits_local[3] = {70, 50, 70};    /* local,
> sensor1, sensor2 */ -static u8 default_limits_chip[3] = {80, 65,
> 80};    /* local, sensor1, sensor2 */ -static const char
> *sensor_location[3] = { "?", "?", "?" }; +static u8 TEMP_REG[3] =
> { 0x26, 0x25, 0x27 };	/* local, sensor1, sensor2 */ +static u8
> LIMIT_REG[3] = { 0x6b, 0x6a, 0x6c };	/* local, sensor1, sensor2
> */ +static u8 MANUAL_MODE[2] = { 0x5c, 0x5d }; +static u8
> REM_CONTROL[2] = { 0x00, 0x40 }; +static u8 FAN_SPEED[2] = { 0x28,
> 0x2a }; +static u8 FAN_SPD_SET[2] = { 0x30, 0x31 };
> +
> +static u8 default_limits_local[3] = { 45, 50, 70 };	/* local,
> sensor1, sensor2 */ +static u8 default_limits_chip[3] = { 70, 65,
> 80 };	/* local, sensor1, sensor2 */ +
> +static const char *sensor_location[3];
>  
>  static int limit_adjust;
>  static int fan_speed = -1;
> -static bool verbose;
> +static int verbose;

You've scattered around quite a few code changes that do things like
change types, indentation, or variable names. You even re-order a couple
functions later on in the code! Your patch says that it's adding support
for reading the hard driver temperature sensor - these formatting
changes don't seem to be related to that goal. (And if they are, you
should mention them in the commit message.)

If you want to clean up the formatting of the source code, feel free to
do so; but it should be done as a separate patch from this one, so that
the individual feature changes and formatting changes can be reviewed
separately. Right now I can't even tell which parts of the patch are
functional changes, related to the goal of cooling your hard drive.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

