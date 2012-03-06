Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030841Ab2CFOzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:55:21 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:5017
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030803Ab2CFOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:55:20 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Query about regmap SPI
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 6 Mar 2012 20:36:11 +0530
Message-ID: <1331046371.32512.31.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I am planning to add SPI support for da7210 codec driver. SPI for this
codec has slightly different format than others. It has 8 bit register
address and 8 bit data. Out of 8 bits of register address, one bit (i.e.
LSB) is used to indicate read or write. Value of 1 at LSB denotes READ
while value of 0 at LSB denotes write operation.

Thus in order for SPI READ to work correctly, the register address need
to be left shifted by one and then ORed with 0x1. In the same way for
SPI WRITE to work correctly, it need to be left shifted by one.

I have gone though the regmap sources and found that ORing can be
achieved by setting correct read_flag_mask. But I couldn't find anything
by which I can tell regmap core to shift the register address before
ORing it with read_flag_mask. Am I missing anything here?

Is there any other way to achieve this using regmap? The only other way
I can think of is providing a wrapper function to read and write in
codec driver and doing the shifting job inside that wrapper.

TIA!


