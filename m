Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0IGAlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 20:41:45 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:43239 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753943Ab0IGAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 20:41:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 824722.78060.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=DNWZ5PBaztyWG7pedSluLnHxqL/jXrzcvlLVC6s6mhn+GRrlOV08KOe51DNCSbNkjzEBDO6gMXvG3uh0ReBDvQMjiJ3/Oe8mYgYuH2iBavaeEqpYW2gHBhazo71S09rqvYhHUpkSuZAmzl+wvUSt6YLq+VmZj7wv14hZx2US5Yw=;
Message-ID: <677002.54522.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: KDxM9YcVM1mRDrsSqST.xo9bwGPs1zZUjsY8VwNBMZ1VcaA
 IU7lxXONyQ.vwtc8sPAblZjjn5cD9EL8az8xntWesZdpINWyDb1JT5.SnNsx
 sY.vfbST3BezG7JsYfH39JKPT_TOUX4wqOsLLYhxnCWE4Vfz3ur9ivTl8M6A
 SzD9q_jFjTFF4K2zOIpPb.OIB_46_ZkDDSvJft3.qovPu2C6GKhpYUTtMn5Z
 p5r1MKc8viAAVzlN3BF7572c0CwVl52xFVjNFXw9wy3hTdxsDFMzXHJtX3N8
 VebWfFy6gSAseoMGbxzJ_3tI5r1Kz0hB5TwEoqUP3OyJ8JvtloawZ_KipOvz
 50LYwhp6QUHqpOg1R.gBPplCT_TgG
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 6 Sep 2010 17:41:42 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
To: Florian Fainelli <florian@openwrt.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>
In-Reply-To: <201009011137.31938.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 9/1/10, Florian Fainelli <florian@openwrt.org> wrote:
> 
> Changes since v3:
> - support daisy-chaining of 74x164 up to 32 gpios

cool, a new feature!



I kind of dislike doing this after having
offereed feedback that you accepted, but I'm going
to NAK this driver for mainline.

The reasons are associated with a point I made in
my last feedback.  The chip interface is SPI (but
it's not called that in the data sheets, true).

This driver is two things:

 - maybe 85% looks like spi-over-gpio, cloning what
the spi-gpio.c driver does (a three-wire SPI mode,
using the NO_RX option, vs normal four-wire).

The rest is a small 74x164 driver.

So if there are spare GPIOs *this* driver can be
used, but not if there's just a spare SPI select.

If this were re-packaged as a small SPI protocol
driver and a small SPI-over-GPIO instance both of
the two components would be more reusable...

Your current hardware can handle the SPI-over-GPIO
approach, obviously.

I'd ack a small 74x164 SPI protocol driver, which is
what I expected when I saw the first post.  But a
conglomerate driver -- no.  Sorry.

- Dave


