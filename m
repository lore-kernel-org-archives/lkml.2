Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2DYF0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:26:35 -0400
Received: from plane.gmane.org ([80.91.229.3]:60685 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2DYF0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:26:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Adrian Yanes <devel@ayanes.com>
Subject: Re: [PATCH] i2c-at91: fix data-loss issue
Date: Wed, 25 Apr 2012 08:26:18 +0300
Message-ID: <jn81tq$b3s$1@dough.gmane.org>
References: <20120413103937.GH7154@arwen.pp.htv.fi> <1334317476-10044-1-git-send-email-h.feurstein@gmail.com> <EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com> <20120418143920.GA19802@pengutronix.de> <4F930B77.8070909@ayanes.com> <EF2E73589CA71846A15D0B2CDF79505D0905DB4657@wm021.weinmann.com> <4F94F598.1040008@ayanes.com>
Reply-To: devel@ayanes.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: duw0.kyla.fi
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.5; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
In-Reply-To: <4F94F598.1040008@ayanes.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently the issue with the AT91RM9200 is the chipset itself due to a
factory design defect. Some people claim that the root cause of it is:

"Since the TWI doesn't have a DMA channel there is no way to deliver
timely data to the Tx buffer under heavy CPU load."[1]

Other threads[2] highlights same issues with the AT91RM9200 and the data
loss. Even in 2007, Ronny Nilsson tried to do some patch[3] blocking the
interrupts in order to win more feasibility, some testing was
performed[4], and up to 100kHz (exactly the same value as we started
getting errors), the driver just failed. At the end of the discussion
the conclusion was that the TWI controller of the AT91RM9200 is just
broken and the GPIO driver is the only alternative.

Therefore, your driver will work for all of those chipsets using PDC
with the TWI. However, it won't work with the AT91RM9200 (and probably
old hardware variants that keep same hardware design).

So I recommend to add a note/comment indicating such incompatibility for
the AT91RM9200, either in the source code or in the kernel config.

Thanks.

Adrian


1 - http://lists.atrpms.net/pipermail/i2c/2007-October/002026.html
2 - http://lists.lm-sensors.org/pipermail/i2c/2007-February/000773.html
3 - http://lists.lm-sensors.org/pipermail/i2c/2007-February/000833.html
4 - http://lists.atrpms.net/pipermail/i2c/2007-October/002034.html

