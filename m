Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2HVWA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:00:27 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:18705
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025Ab2HVWAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:00:17 -0400
X-Forefront-Antispam-Report: CIP:157.56.232.213;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0511HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: PS1(zzzz1202hzz8275bhz32i2a8h668h839h944hd25hf0ah107ah1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: New Defect(s) reported by Coverity Scan
Thread-Topic: New Defect(s) reported by Coverity Scan
Thread-Index: Ac2AsM89FmDALAgBTZWT67Rf+c38yA==
Date: Wed, 22 Aug 2012 22:00:10 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B7026813B3C4A6@BLUPRD0511MB401.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [38.99.3.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity SCAN. 


Defect(s) Reported-by: Coverity Scan:
___________________________________________________________________________
** CID 716812: Unchecked return value (CHECKED_RETURN)
/drivers/platform/x86/ideapad-laptop.c: 639
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=716812


** CID 715732: Macro compares unsigned to 0 (NO_EFFECT)
/drivers/gpu/drm/nouveau/nve0_fifo.c: 307
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=715732


** CID 715543: Dereference before null check (REVERSE_INULL)
/drivers/input/touchscreen/eeti_ts.c: 209
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=715543



###########################################################################
Defect Details:
___________________________________________________________________________
CID 716812: Unchecked return value (CHECKED_RETURN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=716812

/drivers/platform/x86/ideapad-laptop.c: 639 ( check_return)
   636    {
   637    	unsigned long bit, value;
   638    
>>> CID 716812: Unchecked return value (CHECKED_RETURN) Calling function 
>>> "read_ec_data(acpi_handle, int, unsigned long *)" without checking return value (as is done elsewhere 23 out of 25 times).
>>> No check of the return value of "read_ec_data(ideapad_handle, 49, &value)".
   639    	read_ec_data(ideapad_handle, VPCCMD_R_SPECIAL_BUTTONS, &value);
   640    
   641    	for (bit = 0; bit < 16; bit++) {
   642    		if (test_bit(bit, &value)) {
   643    			switch (bit) {
  
 
________________________________________________________________________
CID 715732: Macro compares unsigned to 0 (NO_EFFECT)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=715732

/drivers/gpu/drm/nouveau/nve0_fifo.c: 307 ( unsigned_compare)
   304    	int ret = -EINVAL;
   305    
   306    	spin_lock_irqsave(&dev_priv->channels.lock, flags);
>>> CID 715732: Macro compares unsigned to 0 (NO_EFFECT) This 
>>> greater-than-or-equal-to-zero comparison of an unsigned value is always true. "chid >= 0U".
   307    	if (likely(chid >= 0 && chid < priv->base.channels)) {
   308    		chan = dev_priv->channels.ptr[chid];
   309    		if (likely(chan))
   310    			ret = nouveau_finish_page_flip(chan, NULL);
   311    	}
  
________________________________________________________________________
CID 715543: Dereference before null check (REVERSE_INULL)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=715543

/drivers/input/touchscreen/eeti_ts.c: 202 ( deref_ptr)
   199    
   200    	priv->client = client;
   201    	priv->input = input;
>>> Directly dereferencing pointer "pdata".
   202    	priv->irq_gpio = pdata->irq_gpio;
   203    	priv->irq = gpio_to_irq(pdata->irq_gpio);
   204    
   205    	err = gpio_request_one(pdata->irq_gpio, GPIOF_IN, client->name);
   206    	if (err < 0)
   207    		goto err1;
   208    
>>> CID 715543: Dereference before null check (REVERSE_INULL) 
>>> Null-checking "pdata" suggests that it may be null, but it has already been dereferenced on all paths leading to the check.
   209    	if (pdata)
   210    		priv->irq_active_high = pdata->irq_active_high;
   211    
   212    	irq_flags = priv->irq_active_high ?
   213    		IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
  
________________________________________________________________________


To view the defects in Coverity Scan visit, http://scan5.coverity.com:8080.  
Your username should be the first part of your email address. If you don't have a username, you can request one by emailing: scan-admin@coverity.com
	
Thank you,
Dakshesh Vyas
Coverity SCAN-ADMIN
scan-admin@coverity.com
http://scan.coverity.com

