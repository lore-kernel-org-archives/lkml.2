Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2LFI3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 03:29:40 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18425 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2LFI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 03:29:39 -0500
Date: Thu, 6 Dec 2012 09:29:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benson Leung <bleung@chromium.org>, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, olofj@chromium.org, dudl@cypress.com
Subject: Re: [PATCH v2 1/1] Input: add driver for Cypress APA I2C Trackpad
Message-ID: <20121206092923.54fef9b8@endymion.delvare>
In-Reply-To: <20121206074817.GA25574@core.coreip.homeip.net>
References: <1341959357-14691-1-git-send-email-bleung@chromium.org>
	<1354754899-26701-1-git-send-email-bleung@chromium.org>
	<1354754899-26701-2-git-send-email-bleung@chromium.org>
	<20121206074817.GA25574@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 23:48:17 -0800, Dmitry Torokhov wrote:
> Hi Benson,
> 
> On Wed, Dec 05, 2012 at 04:48:19PM -0800, Benson Leung wrote:
> > This patch introduces a driver for Cypress All Points Addressable
> > I2C Trackpad, including the ones in 2012 Samsung Chromebooks.
> > 
> > This device is compatible with MT protocol type B, providing identifiable
> > contacts.
> > 
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > Signed-off-by: Benson Leung <bleung@chromium.org>
> > ---
> >  Version history :
> > v2 : * Removed firmware update.
> >      * Removed sysfs properties related to firmware update and power mode.
> >      * Folded cyapa_detect into cyapa_probe.
> >      * Added support for middle and right mechanical buttons, if they exist.
> >      * Rearranged disable_irq/enable_irq in suspend and resume to prevent
> >          a power mode change from colliding with a read of tracking data.
> >      * Made cyapa_get_state more reliable.
> >      * Use IRQF_ONESHOT for threaded irq
> >      * Simplified cyapa_set_power_mode.
> >      * Removed extra kernel-doc style comments
> >      * Removed dev_dbg messages.
> >      * Cleaned up unused includes.
> >      * Cleaned up unused #defines
> > v1 : Initial
> 
> First of all - this version is excellent compared to the previous ones
> posted. I have just a few quesutions (and of course I'd like Henrik to
> look over MT handlingi and Jean for I2C bits).

I did not find any problem with the I2C bits.

> > (...)
> > +static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
> > +					u8 *values)
> > +{
> > +	return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, values);
> 
> Does it have to be SMBUS? If it does you need to check the capabilities
> in probe(). 

Using SMBus calls is recommended as it increases portability of the
driver. I2C controllers can do SMBus but SMBus controllers can't do
I2C. Checking the capabilities is needed in both cases anyway, as you
can't assume anything from an i2c_adapter.

-- 
Jean Delvare
