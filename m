Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882Ab2GIECK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:02:10 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:16214
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab2GIECJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:02:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Li Yang-R58472 <r58472@freescale.com>
To: Jia Hongtao-B38951 <B38951@freescale.com>, Greg KH <greg@kroah.com>
CC: Rob Herring <robherring2@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Topic: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Index: AQHNRV2dlnNyMZSYuEOlOpvvM4z7sZb1mBOAgCZoiICAACdsgIAAHF+AgACqUACAA9EmgP//vB4Q
Date: Mon, 9 Jul 2012 03:46:59 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F09354AE6@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1339148585-16947-1-git-send-email-B38951@freescale.com>
 <4FD60FB1.7050106@gmail.com>
 <412C8208B4A0464FA894C5F0C278CD5D01A16829@039-SN1MPN1-002.039d.mgd.msft.net>
 <20120706042611.GA1841@kroah.com>
 <412C8208B4A0464FA894C5F0C278CD5D01A168F2@039-SN1MPN1-002.039d.mgd.msft.net>
 <20120706161718.GA26894@kroah.com>
 <412C8208B4A0464FA894C5F0C278CD5D01A1E694@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <412C8208B4A0464FA894C5F0C278CD5D01A1E694@039-SN1MPN1-002.039d.mgd.msft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't understand, why is this just showing up now?  What changed to
> > cause this?  Couldn't that be the real problem here?
> >
> 
> The issue is showing up because we now probe devices twice.
> Previously, we just probe devices once. But now we changed the way of pci
> init which makes pci controllers should be probed earlier than other
> devices.
> So we have to probe pci nodes separately. Probe more than once is the
> root
> cause of this issue.
> 
> The pci patchset I mentioned please refer to:
> http://patchwork.ozlabs.org/patch/163742/

Let me try to clarify a little bit.  The of platform bus normally traverse the device tree to add all the devices.  The change which caused problem is that we need to probe PCIe RC devices at a earlier stage of initialization.  So we added these PCIe RC devices earlier than the normal device tree traversal process.  These PCIe RC devices will be scanned again during the normal traversal and cause duplicated devices being added.  Our proposal is to deal with duplicated devices automatically and make it possible to scan the device tree multiple times for devices to be added. 

Regards,
Leo

