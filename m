Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1GZIuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:50:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37802 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242Ab1GZIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:50:46 -0400
Date: Tue, 26 Jul 2011 09:50:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: regulator: tps65020 support
Message-ID: <20110726085043.GA7285@opensource.wolfsonmicro.com>
References: <CAM8FrKJ2LAhjvDO9jMZN-D1Sfx=PUuVjMZXBE-E581qdJGxvug@mail.gmail.com>
 <CAM8FrKK1z7euvURCH+ou8uNYumF82bn13oYfBOAiMNiB9zdBJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8FrKK1z7euvURCH+ou8uNYumF82bn13oYfBOAiMNiB9zdBJA@mail.gmail.com>
X-Cookie: Save energy: be apathetic.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 12:03:46AM +0200, Marcus Folkesson wrote:

> This patch gives support for the tps65020 voltage regulator from Texas
> Instruments.
> The support is added to the existing tps65023 regulator.
> 
> It also fixes two bugs:
> * The original driver does not allow core voltage adjustments by the
> I2C bus. (clearing CORE ADJ bit in CTRL2 register).
> * The original driver does not either telling the chip that the
> DEFCORE register i changed by setting the GO bit in CTRL2.
> 
> I have read SubmittingPatches and think all should be okay (this is my
> first submit :-) ), but I still have two questions:

No, a few more issues from SubmittingPatches you need to take care of:

- Use git format-patch -M to show the diff, right now the patch just
  looks like deleting a bunch of files and adding some new ones which is
  very hard to review.
- Split out the bug fixes from the rename, one change per patch.
- Submit in the format specified in SubmittingPatches, not as an
  attachment.

> * The patch is renaming tps65023-regulator.c to tps6502x-regulator.c
> (and edits the corresponding Kconfig/Makefile) since it now handles
> both tps65020 and tps65023. Is this allowed or is the Kconfig and
> Makefile files holy or something?

That's fine but you need to take care of any users.

> * checkpatch.pl is showing two warnings about lines over 80
> characters, but this is not really truth. The lines is splitted up so
> it should not complain. Please take a look.

If you think there's a bug in checkpatch please tell the checkpatch
maintainers.
