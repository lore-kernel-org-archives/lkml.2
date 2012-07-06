Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2GFChD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 22:37:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53443 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2GFCgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 22:36:45 -0400
Message-ID: <1341542187.5303.1.camel@phoenix>
Subject: regulator: Does it make sense to set the same ops for [en|dis]able
 and set_suspend_[en|dis]able?
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Date: Fri, 06 Jul 2012 10:36:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wandering does it make sense to set the same ops for
[en|dis]able and set_suspend_[en|dis]able callbacks.

Or these drivers need fix?

max8952:
static struct regulator_ops max8952_ops = {
        .list_voltage           = max8952_list_voltage,
        .is_enabled             = max8952_is_enabled,
        .enable                 = max8952_enable,
        .disable                = max8952_disable,
        .get_voltage_sel        = max8952_get_voltage_sel,
        .set_voltage_sel        = max8952_set_voltage_sel,
        .set_suspend_disable    = max8952_disable,
};

max8998:
static struct regulator_ops max8998_ldo_ops = {
        .list_voltage           = max8998_list_voltage,
        .is_enabled             = max8998_ldo_is_enabled,
        .enable                 = max8998_ldo_enable,
        .disable                = max8998_ldo_disable,
        .get_voltage_sel        = max8998_get_voltage_sel,
        .set_voltage            = max8998_set_voltage_ldo,
        .set_suspend_enable     = max8998_ldo_enable,
        .set_suspend_disable    = max8998_ldo_disable,
};

static struct regulator_ops max8998_buck_ops = {
        .list_voltage           = max8998_list_voltage,
        .is_enabled             = max8998_ldo_is_enabled,
        .enable                 = max8998_ldo_enable,
        .disable                = max8998_ldo_disable,
        .get_voltage_sel        = max8998_get_voltage_sel,
        .set_voltage            = max8998_set_voltage_buck,
        .set_voltage_time_sel   = max8998_set_voltage_buck_time_sel,
        .set_suspend_enable     = max8998_ldo_enable,
        .set_suspend_disable    = max8998_ldo_disable,
};

static struct regulator_ops max8998_others_ops = {
        .is_enabled             = max8998_ldo_is_enabled,
        .enable                 = max8998_ldo_enable,
        .disable                = max8998_ldo_disable,
        .set_suspend_enable     = max8998_ldo_enable,
        .set_suspend_disable    = max8998_ldo_disable,
};




