Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1IEMrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:47:08 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:35410 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1IEMq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:46:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E64C6B3.80105@cam.ac.uk>
Date: Mon, 05 Sep 2011 13:55:15 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: regmap module_put usage.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I'm playing around with converting an IIO driver over to regmap
(to get a feel for when it makes sense and when it doesn't).

Right now, calling regmap_exit() results in a module_put of the
regmap-spi module which never has a module_get and hence it's
module use count wraps around and all hell breaks loose?

Am I missing something about where that get should occur?

It's entirely plausible I just have a local bug but I right
now I can't see how the logic is supposed to function!

Thanks,

Jonathan
