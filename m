Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1KOTCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:02:47 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:7398 "EHLO
	AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757054Ab1KOTCq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:02:46 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz9371K98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tang Yuantian-B29983 <B29983@freescale.com>
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMo8kl2MospmxCMEqh4kYjCYIqcQ==
Date: Tue, 15 Nov 2011 19:02:39 +0000
Message-ID: <CAOZdJXVq=0pbrPM_-+Kjf3NhON8oN3Me64R6c9qBiAEFuRsDOw@mail.gmail.com>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	<20111115095445.3d34e99e@endymion.delvare>
In-Reply-To: <20111115095445.3d34e99e@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <037EA2EAA4386F478A02CAA238A16809@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 2:54 AM, Jean Delvare <khali@linux-fr.org> wrote:

> This needs careful testing (which I can't do.)

I can test these patches, so please CC me on them.

> There may have been a
> reason why the read was done after the writes. Swapping the commands
> may be the wrong thing to do. The dummy read earlier in this function
> suggests that maybe changes to CCR do not take effect until you read
> from (or write to) the DR register.

Unfortunately, I don't know enough about the I2C protocol to answer
this, but I can provide this description on the DR register from the
reference manual:

         Transmission starts when an address and the R/W bit are
written to the data register and the I2C interface
         performs as the master. A data transfer is initiated when
data is written to the I2CDR. The most significant bit
         is sent first in both cases. In master receive mode, reading
the data register allows the read to occur, but also
         allows the I2C module to receive the next byte of data on the
I2C interface. In slave mode, the same function
         is available after it is addressed. Note that in both master
receive and slave receive modes, the very first read
         is always a dummy read.

> Can't the above be rewritten to keep the order of the commands as it
> was before? AFAICS it would only take one or two extra tests.

I think it's very important to keep the order as-is, if at all
possible.  This driver is very old and the hardware is used on all of
our SOCs, dating back several years.  It would be a nightmare to test
it all over again.

-- 
Timur Tabi
Linux kernel developer at Freescale
