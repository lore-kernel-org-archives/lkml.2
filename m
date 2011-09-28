Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1I1WjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab1I1WjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.030738287@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Johan Hovold <jhovold@gmail.com>
Subject: [045/244] regulator: tps65910: Add missing breaks in switch/case
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit d04156bca629740a661fd0738cd69ba1f08b2b20 upstream.

Also add a default case in tps65910_list_voltage_dcdc to silence
'volt' may be used uninitialized in this function warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/tps65910-regulator.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -759,8 +759,13 @@ static int tps65910_list_voltage_dcdc(st
 		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
 		volt = VDD1_2_MIN_VOLT +
 				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
+		break;
+	default:
+		BUG();
+		return -EINVAL;
 	}
 
 	return  volt * 100 * mult;
@@ -898,9 +903,11 @@ static __devinit int tps65910_probe(stru
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
 		info = tps65910_regs;
+		break;
 	case TPS65911:
 		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
 		info = tps65911_regs;
+		break;
 	default:
 		pr_err("Invalid tps chip version\n");
 		return -ENODEV;


