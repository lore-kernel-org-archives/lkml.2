Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2CDWRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:17:09 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:9346 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab2CDWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:17:08 -0500
X-IronPort-AV: E=Sophos;i="4.73,531,1325458800"; 
   d="scan'208";a="147476417"
Date: Sun, 4 Mar 2012 23:17:04 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] edac: move const pci_device_id tables from __devinitdata
 to __devinitconst.
In-Reply-To: <20120227061300.GC4763@mwanda>
Message-ID: <alpine.DEB.2.02.1203042310100.2919@hadrien>
References: <791782.71473.bm@smtp128.mail.ukl.yahoo.com> <20120227061300.GC4763@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also looked at whether PCI_DEVICE and PCI_DEVICE_CLASS could be used 
more often, and came up with the semantic patch shown below.  This should 
work with the current release of Coccinelle.  This affects 40 files, only 
one of which can use PCI_DEVICE_CLASS.  Perhaps it could be useful to 
generalize it.  Again, I don't have time now to look into it in more 
detail, but can provide the results if somone is interested.

julia

@@
identifier id;
expression dev_class, dev_class_mask;
@@

struct pci_device_id id[] = {
   ...,
   {
-   .class = (dev_class), .class_mask = (dev_class_mask),
-   .vendor = PCI_ANY_ID, .device = PCI_ANY_ID,
-   .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID,
+   PCI_DEVICE_CLASS(dev_class,dev_class_mask),
   },
   ...
};

@@
identifier id;
declarer name DEFINE_PCI_DEVICE_TABLE;
expression dev_class, dev_class_mask;
@@

DEFINE_PCI_DEVICE_TABLE(id) = {
   ...,
   {
-   .class = (dev_class), .class_mask = (dev_class_mask),
-   .vendor = PCI_ANY_ID, .device = PCI_ANY_ID,
-   .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID,
+   PCI_DEVICE_CLASS(dev_class,dev_class_mask),
   },
   ...
};

@@
identifier id;
expression vend, dev;
@@

struct pci_device_id id[] = {
   ...,
   {
-   .vendor = (vend), .device = (dev),
-   .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID,
+   PCI_DEVICE(vend,dev),
   },
   ...
};

@@
identifier id;
expression vend, dev;
@@

DEFINE_PCI_DEVICE_TABLE(id) = {
   ...,
   {
-   .vendor = (vend), .device = (dev),
-   .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID,
+   PCI_DEVICE(vend,dev),
   },
   ...
};
