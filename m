Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0JMTzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:55:49 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34248 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0JMTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:55:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
Date: Wed, 13 Oct 2010 13:54:31 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@kernellabs.com>
References: <142752.33963.qm@web25408.mail.ukl.yahoo.com>
In-Reply-To: <142752.33963.qm@web25408.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131354.31647.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 13, 2010 01:02:11 pm fabio tirapelle wrote:
> After upgrading from Ubuntu 9.10 to Ubuntu 10.04 my Hauppauge WinTV-HVR-1120 
> (sometimes) doesn't work correctly.
> I get random the following errors:
> 
> tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
> tda18271_init: error -5 on line 826
> tda18271_tune: error -5 on line 904
> tda18271_set_params: error -5 on line 985

I cc'd Michael since he made several recent tda18271 changes.

This page: http://cvs.linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
suggests that the card might work, despite the error messages.  Does
yours work?

I see that tda18271_write_regs() uses i2c_transfer(), which uses the
adap->algo->master_xfer function pointer, but I don't know enough to
figure out which master_xfer implementation might be used on your
system.  A complete dmesg log and lspci output might have a hint.

Can you reproduce this on an upstream kernel?  It would be good to
make sure that it's not something introduced by an Ubuntu patch or
fixed since the Ubuntu kernel snapshot.

Bjorn

> Part of dmesg of 11-OCT-2010
> 
> [   53.216153] DVB: registering new adapter (saa7133[0])
> [   53.216156] DVB: registering adapter 2 frontend 0 (NXP TDA10048HN DVB-T)...
> [   53.840013] tda10048_firmware_upload: waiting for firmware upload 
> (dvb-fe-tda10048-1.0.fw)...
> [   53.840019] saa7134 0000:01:06.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> [   53.880505] tda10048_firmware_upload: firmware read 24878 bytes.
> [   53.880509] tda10048_firmware_upload: firmware uploading
> [   58.280136] tda10048_firmware_upload: firmware uploaded
> [   59.024537] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [   59.024541] tda18271c2_rf_tracking_filters_correction: error -5 on line 264
> [   59.420153] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [   59.420157] tda18271_toggle_output: error -5 on line 47
> [   91.004019] Clocksource tsc unstable (delta = -295012684 ns)
> [  256.293639] eth0: link up.
> [  256.294750] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  263.523498] eth0: link down.
> [  265.258740] eth0: link up.
> [  266.460026] eth0: no IPv6 routers present
> [ 9869.636167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [ 9869.636178] tda18271_init: error -5 on line 826
> [ 9872.636220] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [ 9872.636232] tda18271_toggle_output: error -5 on line 47
> [ 9998.240167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [ 9998.240178] tda18271_init: error -5 on line 826
> [10001.240179] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [10001.240190] tda18271_toggle_output: error -5 on line 47
> 
> And this is the dmesg of today: even the same errors.
> 
> [  741.252183] tda18271_init: error -5 on line 826
> [  741.252188] tda18271_tune: error -5 on line 904
> [  741.252193] tda18271_set_params: error -5 on line 985
> [  742.268174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  742.268184] tda18271_init: error -5 on line 826
> [  742.268189] tda18271_tune: error -5 on line 904
> [  742.268194] tda18271_set_params: error -5 on line 985
> [  743.284174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  743.284184] tda18271_init: error -5 on line 826
> [  743.284190] tda18271_tune: error -5 on line 904
> [  743.284194] tda18271_set_params: error -5 on line 985
> [  744.300169] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  744.300180] tda18271_init: error -5 on line 826
> [  744.300185] tda18271_tune: error -5 on line 904
> [  744.300190] tda18271_set_params: error -5 on line 985
> [  745.320172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  745.320183] tda18271_init: error -5 on line 826
> [  745.320188] tda18271_tune: error -5 on line 904
> [  745.320193] tda18271_set_params: error -5 on line 985
> [  746.336174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  746.336185] tda18271_init: error -5 on line 826
> [  746.336190] tda18271_tune: error -5 on line 904
> [  746.336195] tda18271_set_params: error -5 on line 985
> [  747.352170] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  747.352181] tda18271_init: error -5 on line 826
> [  747.352187] tda18271_tune: error -5 on line 904
> [  747.352192] tda18271_set_params: error -5 on line 985
> [  748.368172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  748.368183] tda18271_init: error -5 on line 826
> [  748.368188] tda18271_tune: error -5 on line 904
> [  748.368193] tda18271_set_params: error -5 on line 985
> [  749.384179] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  749.384191] tda18271_init: error -5 on line 826
> [  749.384196] tda18271_tune: error -5 on line 904
> [  749.384202] tda18271_set_params: error -5 on line 985
> [  750.400172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  750.400182] tda18271_init: error -5 on line 826
> [  750.400188] tda18271_tune: error -5 on line 904
> [  750.400194] tda18271_set_params: error -5 on line 985
> [  751.424170] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
> [  751.424181] tda18271_init: error -5 on line 826
> [  751.424186] tda18271_tune: error -5 on line 904
> [  751.424192] tda18271_set_params: error -5 on line 985
> [  752.440172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
> returned: -5
>                                                                                                                                        
>  
> 
> Any ideas?
> Thanks
> 
> 
>       
> 
