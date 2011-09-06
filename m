Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1IFLGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 07:06:39 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:55357 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1IFLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:06:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E6600A8.4020101@cam.ac.uk>
Date: Tue, 06 Sep 2011 12:14:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Blockers on IIO usage of regmap.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Just a quick heads up that the big blocker for
us making more use of regmap is lack of default
control of cs_change for spi buses.  That leads to
a lot of hand crafted spi read / write routines and
is rather tedious.

When I have the time I'll look into sorting that side
out.

Also, we will need a couple of variants of bulk read for
spi. Classic ones are 

TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXX
RX  XXXXXXXXXXX Da0.....Da7  Db0.....Db7  etc

TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXXXX
RX  XXXXXXXXXXX XXXXXXXXXXX  Da0.....Da7  Db0....Db7

TX  Ada0...Ada7  Adb1...Adb7 Adc1...Adc7  etc
RX  XXXXXXXXXXX  Da0.....Da7 Db0.....Db7  etc

Last one is a kind of 'simulated' bulk read where address is simply incremented
(just for complexity that increment may well be by 2 rather than one...)
That one is only sort of a 'bulk' read, but rather common.

So basically we need some bus specific 'mode' hook somewhere.
Given we have separate init functions for the buses could we
add a struct regmap_spi_config to the parameter list?

IIRC IIO has several drivers in each of the above categories so sharing
the code via regmap would be great!

What do you think?

Jonathan
