Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2AWIwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 03:52:17 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30661 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2AWIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 03:52:16 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: mfd regmap irq to handle some cases
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jan 2012 14:17:03 +0530
Message-ID: <1327308423.23929.8.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

DA9052-53 PMIC supports Tick & Periodic Alarm. On expiry of Alarm an event gets generate
and data ( about the alram type - Tick or Periodic) also gets lock in a register. This
data needs to be read from the register before event is cleared . But since in regmap irq
events are cleared first and then left for processing (which is the obvious way to do) but
in this approach data gets loss from the DA9052-53 register and alarm type cannot be
determined.

For a quick fix in regmap irq we may tempt to defer event clarification after processing of
event but there is a problem in this approach for some variants of DA9052 and DA9053 when
event is cleared a spurious interrupt gets generated therefore in earlier release of DA9052/53
MFD module a delay was added. Therefore we need to think on how to handle such cases in regmap irq.

Regards,
Ashish


