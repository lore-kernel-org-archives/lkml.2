Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1FVNx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:53:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45435 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:53:57 -0400
Date: Wed, 22 Jun 2011 15:53:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Reim <thomas.reim@nepomuc.de>
Cc: Thomas Reim <reimth@googlemail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error 
 flooding problem
Message-ID: <20110622155330.419226df@endymion.delvare>
In-Reply-To: <1308705084.3556.74.camel@Mark-Aurel.gas.de>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
 <20110621212705.1420c63e@endymion.delvare>
 <1308705084.3556.74.camel@Mark-Aurel.gas.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Thomas,

On Wed, 22 Jun 2011 03:11:24 +0200, Thomas Reim wrote:
> Salut Jean, 
> 
> thank you for the detailed reply. If I got you right you rose the
> following main points:
> 1. Root cause leading to flooding problem (you assume i2c bus not 
>    working correctly, i. e. "stuck bus") not adequately addressed by 
>    the fix 
> 2. Alternative proposal: Fix the verbose logging issue
> 3. i2c EDID probing inefficiently implemented
> 4. Strange coding and commenting style

Yes, this is a good summary.

> 
> Point 1:
> The Asus M2A-VM HDMI EDID error flooding problem was already addressed
> in this mailing list in April this year
> (https://lkml.org/lkml/2011/4/15/36). But it was not further discussed,

This is more of a workaround than a bug fix.

> maybe due to missing bug information. I wanted to provide this
> information to that thread, but your mail was faster :-). In the
> following, you can see the i2c dump of the DVI connector of the AMD 690G
> chip, where the monitor is connected to:
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 00 ff ff ff ff ff ff 00 4c 2d ed 00 39 31 49 44    ........L-?.91ID
> 10: 2d 0e 01 03 80 26 1e 78 2a ee 95 a3 54 4c 99 26    -????&?x*???TL?&
> 20: 0f 50 54 bf ef 80 81 80 71 4f 01 01 01 01 01 01    ?PT?????qO??????
> 30: 01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70    ??????0*.?Q.*@0p
> 40: 13 00 78 2d 11 00 00 1e 00 00 00 fd 00 38 4c 1e    ?.x-?..?...?.8L?
> 50: 51 0e 00 0a 20 20 20 20 20 20 00 00 00 fc 00 53    Q?.?      ...?.S
> 60: 79 6e 63 4d 61 73 74 65 72 0a 20 20 00 00 00 ff    yncMaster?  ....
> 70: 00 48 34 4a 58 42 30 31 35 30 33 0a 20 20 00 e4    .H4JXB01503?  .?
> 80: 00 ff ff ff ff ff ff 00 4c 2d ed 00 39 31 49 44    ........L-?.91ID
> 90: 2d 0e 01 03 80 26 1e 78 2a ee 95 a3 54 4c 99 26    -????&?x*???TL?&
> a0: 0f 50 54 bf ef 80 81 80 71 4f 01 01 01 01 01 01    ?PT?????qO??????
> b0: 01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70    ??????0*.?Q.*@0p
> c0: 13 00 78 2d 11 00 00 1e 00 00 00 fd 00 38 4c 1e    ?.x-?..?...?.8L?
> d0: 51 0e 00 0a 20 20 20 20 20 20 00 00 00 fc 00 53    Q?.?      ...?.S
> e0: 79 6e 63 4d 61 73 74 65 72 0a 20 20 00 00 00 ff    yncMaster?  ....
> f0: 00 48 34 4a 58 42 30 31 35 30 33 0a 20 20 00 e4    .H4JXB01503?  .?

Looks very good.

> 
> Then we have the i2c dump of the HDMI connector with no monitor
> connected: 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 00 00 00 00 00 00 00 00 00 00 1f 00 00 00 00 00    ..........?.....
> 10: 00 00 00 00 00 XX 00 01 00 00 00 00 1f 00 00 00    .....X.?....?...
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> 30: 00 00 00 00 00 XX 00 00 00 00 00 7f 00 00 00 00    .....X.....?....
> 40: 00 00 1f 00 00 00 00 00 00 00 00 00 00 00 00 00    ..?.............
> 50: 00 00 00 00 00 07 00 01 00 00 00 00 00 00 00 00    .....?.?........
> 60: 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00    .....?..........
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> 80: 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> 90: 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00    .....?..........
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> b0: 00 00 00 00 00 ff 00 00 3f 00 00 00 00 00 00 00    ........?.......
> c0: 00 00 00 00 00 00 00 00 00 03 00 00 00 00 00 00    .........?......
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> f0: 00 00 00 00 XX 00 00 7f 00 00 00 00 00 00 00 00    ....X..?........

Obviously bogus. Is the result similar with a second dump, or is this
"moving noise"?

Can you post the output of i2cdetect for this i2c adapter?

I guess that the I2C adapter doesn't get created at all if you pass
bit_test=1 to module i2c-algo-bit?

I admit that the above is a little different from what I expected (all
zeroes). My initial proposal of only reading the first 2 bytes of the
EEPROM is too weak given the output above, but reading 3 or 4 bytes
should be sufficient.

Did you try connecting a monitor to the HDMI port? I am curious if
reading the EDID will work reliably or not. This is a very important
point to figure out what exactly is going on at the hardware level.
Even better would be if you could try with several monitors, and/or
compare the same EDID read from your system over HDMI and read from
another, known good system (or yours over DVI for example.)

Could the problem come from the fact that the HDMI connector is on a
separate riser card on your board, which maybe you don't use at all? If
so, could you please plug it in and see if it helps?

> 
> For this connector radeon_ddc_probe() reports a working DDC, which leads
> to the catastrophic situation that drm_get_edid() and
> drm_edid_block_valid() flood the logs with EDID error messages and
> dumps.

I understand that.

> 
> Finally, we have the i2c dump of the VGA connector, where also no
> monitor is connected to:
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 40: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 50: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 60: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 70: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 80: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 90: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> a0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> b0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> c0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> d0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> e0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> f0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
> 
> radeon_ddc_probe() reports no DDC.

Yes, this is what the HDMI port should report as well: no ack from the
EEPROM chip, as there is no EEPROM at all.

> 
> Do you really believe that this is caused by a stuck i2c bus?

Almost. A SDA line stuck low would report zeroes all around the place,
which isn't the case here. Normally the neutral state of an I2C bus is
SCL and SDA high, so you should have pull-up resistors on each wire.
Only if a master or slave actively pulls the lines down, should they go
low. This is obviously not the case on your HDMI connector, as we see
noise in the dump.

If there no alternative way to know if an HDMI connector is populated
or not?

> Following
> the i2c dumps it really makes sense to add a limited check of some major
> EDID parts from i2c register for DDC probing. Current radeon_ddc_probe()
> just checks that we CAN get data from i2c register 0x50 and leaves the
> rest to the log flooding drm_edid functions.

Correct.

> Point 2:
> Your proposal has been intensively discussed after release of kernel
> 2.35. Many users suffered from this log flooding. Many people proposed
> fixes, e. g. log EDID errors only once. None of the proposals was taken
> over by the kernel developers. The linux distributions' bug lists are
> full of these unsolved bug reports. Also in kernel 3.0 no solution was
> released. For me that means, kernel people have stringent reasons to NOT
> touch the log flooding functions in DRM. Therefore, I spent my time to
> fix the problem in the hardware related domain. And the few changes in
> radeon code have solved the problem from 2.35 up to the latest 3.0 git
> version.

Probably preaching in the desert if this was discussed before, but...

IHMO, this error message reporting should be disabled when EDID polling
is enabled. Not just for your specific case, but in general. If the
EDID is invalid for any reason (including damaged EEPROM or
non-conforming display) it won't get fixed magically, so an error once
means an error forever, and it's pointless to repeat the same error
message forever.

Alternatively, we could remember that the error message was printed,
and stop printing it until at least one validation passes (different
screen connected, or transient error gone.)

> Point 3:
> > I don't like this. radeon_ddc_edid_probe() is partly redundant with
> > radeon_ddc_probe() and also partly redundant with drm_get_edid() and
> > drm_edid_is_valid(). It will add yet another round of I2C transactions,
> > and these transactions are slow, so the fewer we have at driver load
> > time, the happier we are. This is even more true these days when every
> > graphics card gets 8 I2C buses created.
> > 
> > If nothing else, you should call radeon_ddc_edid_probe() instead of,
> > not after, radeon_ddc_probe(), to save a transaction.
> 
> This is correct, I was not sure about possible side effects. Therefore,
> I used both functions in my first proposal but limited the new one to
> the DRM_MODE_CONNECTOR_HDMIA types of the eight i2c busses. 

I understand that you wanted to be as little intrusive as possible.
However, your current approach will still slow down probing on many
unrelated systems (many cards have an HDMI connector... most recent
cards, I'd say), while still not addressing the general case: what if
another system has similar problems on a different connector type?

So you are half-way to a generic fix. I'd rather got for a board
specific fix (as Alex Deucher proposed) or a truly generic fix (not
limited to a specific connector type.)

> > +bool radeon_ddc_edid_probe(struct radeon_connector *radeon_connector)
> > > +{
> > > +	u8 out_buf[] = { 0x0, 0x0};
> > 
> > You only use the first byte (same in radeon_ddc_probe, could be
> > optimized.)
> > 
> > > +	u8 block[20];
> > > +	int ret;
> > > +	struct i2c_msg msgs[] = {
> > > +		{
> > > +			.addr	= 0x50,
> > > +			.flags	= 0,
> > > +			.len	= 1,
> > > +			.buf	= out_buf,
> > > +		}, {
> > > +			.addr	= 0x50,
> > > +			.flags	= I2C_M_RD,
> > > +			.len	= 20,
> > > +			.buf	= block,
> > > +		}
> > > +	};
> > > +
> > > +	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
> > 
> > You are reading 20 bytes when you really only need 10. It would be more
> > efficient to read 8 bytes first, and only if needed, the two remaining
> > ones..
> 
> What shall we do? On the one hand you complain about the intensive use
> of the slow i2c bus. On the other hand you ask to add a second check for
> the good case, when we get a valid EDID via i2c.

My point was simply that it is faster to read 8 bytes and then 2 bytes
than 20 bytes. As a side bonus, you don't even have to read the last 2
bytes, if the 8 first aren't OK. But again this was really a
theoretical point, as I don't think there is any point in reading that
much from the EDID, when the problem is already visible within the
first few bytes.

> I'm not experienced at
> all in i2c bus driver handling. How would we have to change both
> radeon_ddc probing functions to request only the first byte?

radeon_ddc_probe() is already doing exactly that. My proposal (if and
only if we want to go for a generic fix) is to simply extend
radeon_ddc_probe() to read a few more bytes. That being said, we have
to be cautious: looking at drm_edid_block_valid(), I can see that it
has some tolerance and accepts EDID where only 6 of the first 8 bytes
match the standard signature. Your own proposal is stricter than this.

This really makes me believe that the layering between the drm helpers
and the radeon driver is not optimal. drm_edid_block_valid() is being
called too late in the chain, when apparently this is what you'd need
(at least the first part) to detect the broken I2C bus on your HDMI
connector early.

The sole fact that function radeon_ddc_probe() exists in driver radeon
while it has very little radeon-specific logic in it [1], seems wrong.
Ignoring this thought for a moment, an easy, general workaround for
your problem would be:

---
 drivers/gpu/drm/drm_edid.c          |   23 ++++++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_i2c.c |   10 +++++-----
 include/drm/drm_crtc.h              |    1 +
 3 files changed, 24 insertions(+), 10 deletions(-)

--- linux-3.0-rc4.orig/drivers/gpu/drm/drm_edid.c	2011-06-21 10:30:19.000000000 +0200
+++ linux-3.0-rc4/drivers/gpu/drm/drm_edid.c	2011-06-22 13:49:10.000000000 +0200
@@ -128,6 +128,23 @@ static const u8 edid_header[] = {
 };
 
 /*
+ * Sanity check the header of the base EDID block.  Return 8 if the header
+ * is perfect, down to 0 if it's totally wrong.
+ */
+int drm_edid_header_valid(const u8 *raw_edid)
+{
+	int i, score = 0;
+
+	for (i = 0; i < sizeof(edid_header); i++)
+		if (raw_edid[i] == edid_header[i])
+			score++;
+
+	return score;
+}
+EXPORT_SYMBOL(drm_edid_header_valid);
+
+
+/*
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
  */
@@ -139,11 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
 	struct edid *edid = (struct edid *)raw_edid;
 
 	if (raw_edid[0] == 0x00) {
-		int score = 0;
-
-		for (i = 0; i < sizeof(edid_header); i++)
-			if (raw_edid[i] == edid_header[i])
-				score++;
+		int score = drm_edid_header_valid(raw_edid);
 
 		if (score == 8) ;
 		else if (score >= 6) {
--- linux-3.0-rc4.orig/drivers/gpu/drm/radeon/radeon_i2c.c	2011-05-30 20:45:08.000000000 +0200
+++ linux-3.0-rc4/drivers/gpu/drm/radeon/radeon_i2c.c	2011-06-22 12:00:35.000000000 +0200
@@ -34,20 +34,20 @@
  */
 bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 {
-	u8 out_buf[] = { 0x0, 0x0};
-	u8 buf[2];
+	u8 out = 0x0;
+	u8 buf[8];
 	int ret;
 	struct i2c_msg msgs[] = {
 		{
 			.addr = 0x50,
 			.flags = 0,
 			.len = 1,
-			.buf = out_buf,
+			.buf = &out,
 		},
 		{
 			.addr = 0x50,
 			.flags = I2C_M_RD,
-			.len = 1,
+			.len = 8,
 			.buf = buf,
 		}
 	};
@@ -57,7 +57,7 @@ bool radeon_ddc_probe(struct radeon_conn
 		radeon_router_select_ddc_port(radeon_connector);
 
 	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
-	if (ret == 2)
+	if (ret == 2 && drm_edid_header_valid(buf) >= 6)
 		return true;
 
 	return false;
--- linux-3.0-rc4.orig/include/drm/drm_crtc.h	2011-06-21 10:30:19.000000000 +0200
+++ linux-3.0-rc4/include/drm/drm_crtc.h	2011-06-22 12:02:24.000000000 +0200
@@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
 
+extern int drm_edid_header_valid(const u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);


But if Alex believes that the case is rare enough that a board-specific
workaround is better, that's totally fine with me too. He is the master!

> Point 4:
> I've checked your comments and updated the patch. Hopefully, it fits now
> better to the linux kernel coding style. Thank you for the hints.
> 
> 
> A subsequent mail will contain the updated patch proposal. 

[1] I wonder why radeon_router_select_ddc_port() isn't part of
pre_xfer().

-- 
Jean Delvare
