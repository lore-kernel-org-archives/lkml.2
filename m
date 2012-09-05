Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2IEJBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:01:47 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43697 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472Ab2IEJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:01:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/2] pinctrl: pinctrl-single: new type: pinctrl-single,bits
Date: Wed,  5 Sep 2012 12:01:56 +0300
Message-Id: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When configuring pinmux with pinctrl-single there could be a case when one
register is used to configure mux for more than one pin.
In this case the use of pinctrl-single,pins is a bit problematic since we can
only update the whole register (restricted by the mask).
In such a situations the pinctrl-single,bits could provide a safe way to handle
the mux.

pinctrl-single,bits takes three parameters: <reg offset, value, sub-mask>
The sub mask is used to mask part of the register to make sure we do not change
bits outside of the scope of this pin.

The first patch in this series is to fix the previous pinctrl-since,pins
implementation because it was not using the mask on the value which could result
changed bits outside of the mask.

Regards,
Peter
---
Peter Ujfalusi (2):
  pinctrl: pinctrl-single: Make sure we do not change bits outside of
    mask
  pinctrl: pinctrl-single: Add pinctrl-single,bits type of mux

 .../devicetree/bindings/pinctrl/pinctrl-single.txt |  9 +++++
 drivers/pinctrl/pinctrl-single.c                   | 42 ++++++++++++++++------
 2 files changed, 41 insertions(+), 10 deletions(-)

-- 
1.7.12

