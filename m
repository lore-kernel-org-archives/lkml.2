Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0JRPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:38:30 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:23099 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755921Ab0JRPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:38:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=1bPbgMPW5RndkjhwhbQP9M1tgLgCRIMk8VCDqXdrp5hRsmGv7Yn4YJh1TiOcMETOnx317SAJ0JjdQKi6ud9SY3rAOy/R2jR+DJY+uwwXGyXPHl1jLGBVFxQlnazwKHqQkHVbz4jOKH+/U+KOSR4H8xIIFSPTB/sf6WV8KsDldl8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Eesc3dkVM1nMNZuSh1sTCBf.BiEksZW5dw6eEBKvFHsznb6
 t24AsbBJwOzsjVc8_1bmh9c1l179fJhcdgFHoOUX84vlthO33X.1Cbi9oPuP
 j1WunL7PUWvAdpwfYWXrJy0ueFvapZVmFFj.U.FYzNg7S93ozl1_wzKXhrMU
 CWw5hXxYCqeo.c_IHM7TWnJLiTxDr5xzWxy8oBmQgAPiMKKDm1h6keBmrPDK
 0BAjO.UJzRQ0YonCb8Vc1mIpnJC9YnnnEPRccYI97FdO_pY2L4aKXnhaLpDr
 2iQZ8J1U0ySQ0EiQuH5yaJxo-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] i2c: add irq_flags to board info
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
In-Reply-To: <20101018163357.659efe25@endymion.delvare>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org>
	 <20101018103610.77b7e605@endymion.delvare>
	 <544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com>
	 <20101018140136.2b44d29e@endymion.delvare>
	 <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
	 <20101018163357.659efe25@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Oct 2010 08:38:25 -0700
Message-ID: <1287416305.2038.70.camel@helium>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:33 +0200, Jean Delvare wrote:


> 
> This is an interesting point. David, you're the one who added irq to
> struct i2c_client, you didn't add irq_flags then, did you have a good
> reason not to?

There was no evident need to do so.  The problem wasn't characterizing
the IRQ, but knowing what IRQ was associated with a given I2C chip.  The
IRQs would, as a rule, only have one behavior, known in advance by the
I2C chip's driver ... if it only had a way to know client->irq ...

In one model of IRQ setup (like PC BIOS), it's handled before drivers
do more than request the IRQ, and drivers just cope. irq_flags not
needed ... it's often a hardware-to-driver convention, likely matching
I2C chip defaults.  (Or more awkwardly, coping with whatever trigger
mode the platform uses).

In another model, drivers configure their chips according to desired
mode (level low, for the most common example, or edge triggered, etc)
and again, irq_flags not needed, but in this case the platform code
would have had *nothing* do do with such mode setup.



> 
> > There are drivers that work around this deficiency, by adding irq_flags to the bus clients dev.platform_data
> > See include/linux/spi/ads7846.h for one example.

Not a good example; that was changed earlier this year and, from a quick
glance, may not have tried much to avoid that change.  The driver had
worked for years with that alleged "deficiency".


- Dave

