Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2LUNZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:25:08 -0500
Received: from grace.univie.ac.at ([131.130.3.115]:35791 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2LUNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:24:58 -0500
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 08:24:58 EST
Message-ID: <130520f664cf9c20926d37c307c97ea8.squirrel@webmail.univie.ac.at>
Date: Fri, 21 Dec 2012 14:12:16 +0100
Subject: starting up i2c regulator?
From: "Piotr Sawuk" <a9702387@unet.univie.ac.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Univie-Virus-Scan: scanned by ClamAV on justin.univie.ac.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a gpl driver for lsm202dlh which worked with 2.6 kernels. now in 3.5
I can modprobe it (after some include-changes), but after the echo command
to new_device dmesg tells me

[ 1147.549042] lsm303dlh_a 6-0019: failed to get regulator
[ 1147.549055] lsm303dlh_a 6-0019: probe function fails fffffdfb
[ 1147.549067] i2c 6-0019: Driver lsm303dlh_a requests probe deferral
[ 1147.549078] i2c i2c-6: new_device: Instantiated device lsm303dlh_a at 0x19

and some kind of generic files in sysfs are created but not the ones that
driver should create. the driver does obviously do

	ddata->regulator = regulator_get(&client->dev, "vdd");
	if (IS_ERR(ddata->regulator)) {
		dev_err(&client->dev, "failed to get regulator\n");
		ret = PTR_ERR(ddata->regulator);
		ddata->regulator = NULL;
		goto err_op_failed;
	}
...
err_op_failed:
	kfree(ddata);
err_alloc:
	dev_err(&client->dev, "probe function fails %x", ret);
	return ret;


so my question is, what is the meaning of fffffdfb being returned from
regulator_get(dev,"vdd")? is there anything that needs to be done to let the
driver run on newer kernel? in applesmc.c I see nothing about "regulator"
being mentioned, is that whole thing gone?

P

