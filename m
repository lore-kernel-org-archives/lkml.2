Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1FVQRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:17:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4254 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab1FVQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:17:01 -0400
Date: Wed, 22 Jun 2011 18:16:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH 1/3] light sensor: Add SMBUS support to the tsl2563
 driver.
Message-ID: <20110622181649.2881f439@endymion.delvare>
In-Reply-To: <4E02100C.2000408@cam.ac.uk>
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
	<4E01B068.3090102@cam.ac.uk>
	<20110622161035.5bfe2a73@endymion.delvare>
	<4E02100C.2000408@cam.ac.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 16:53:48 +0100, Jonathan Cameron wrote:
> On 06/22/11 15:10, Jean Delvare wrote:
> > On Wed, 22 Jun 2011 10:05:44 +0100, Jonathan Cameron wrote:
> >> On 06/21/11 23:54, Bryan Freed wrote:
> >>> +	if (use_smbus) {
> >>> +		if (len == 1) {
> >>> +			ret = i2c_smbus_read_byte_data(client, cmd);
> >>> +			buf[0] = ret & 0xff;
> >>> +		} else if (len == 2) {
> >>> +			ret = i2c_smbus_read_word_data(client, cmd);
> >>> +			buf[0] = ret & 0xff;
> >>> +			buf[1] = (ret >> 8) & 0xff;
> > 
> > swab16 is your friend (and the bogus SMBus byte order convention be
> > damned.)
>
> I would imagine the be16_to_cpu etc is even better as we don't know the
> cpu endianess.

No, it has to do with SMBus endianess vs. I2C chip endianess, not host
endianess. SMBus specifies that the low byte of a word goes on the wire
first, but almost all I2C and SMBus devices I've see implement it the
other way around, high byte first. i2c-core's
i2c_smbus_read_word_data() stick to the specs, so for almost all I2C
devices, the driver has to swab16 the result.

(I didn't check the TSL2563 datasheet though... maybe this is one of
the rare chips that don't need it.)

-- 
Jean Delvare
