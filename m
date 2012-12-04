Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2LDUHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:07:46 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17389 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LDUHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:07:43 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Joe Perches <joe@perches.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 3/3] aerdrv: Cleanup log output for CPER based AER
Thread-Topic: [PATCH v6 3/3] aerdrv: Cleanup log output for CPER based AER
Thread-Index: AQHN0kZT7OGOdKXJTk6UBaMIOmzAsZgJD/AQ
Date: Tue, 4 Dec 2012 20:06:48 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EEAB4@G4W3218.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
	 <20121204170442.31397.21190.stgit@grignak.americas.hpqcorp.net>
 <1354642763.6973.15.camel@joe-AO722>
In-Reply-To: <1354642763.6973.15.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi again Lance.
> 
> > diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c
> b/drivers/pci/pcie/aer/aerdrv_errprint.c
> []
> > @@ -228,9 +228,14 @@ void cper_print_aer(struct pci_dev *dev, int
> cper_severity,
> >  	int aer_severity, layer, agent, status_strs_size,
> tlp_header_valid = 0;
> >  	u32 status, mask;
> >  	const char **status_strs;
> > -	char *prefix = NULL;
> > +	char prefix[44];
> >
> >  	aer_severity = cper_severity_to_aer(cper_severity);
> > +	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
> > +		(aer_severity == AER_CORRECTABLE) ?
> > +		KERN_WARNING : KERN_ERR,
> > +		dev_driver_string(&dev->dev), dev_name(&dev->dev));
> > +
> >  	if (aer_severity == AER_CORRECTABLE) {
> >  		status = aer->cor_status;
> >  		mask = aer->cor_mask;
> 
> Perhaps this would be better just using dev_printk
> instead of snprintf into a prefix with printk to
> emulate dev_printk.
> 
> Also, perhaps KERN_NOTICE is preferable to KERN_WARNING
> in the CORRECTABLE case.
> 
> Maybe something like:
> 
> 	const char *level = KERN_ERR;
> 	if (aer_severity == AER_CORRECTABLE)
> 		level = KERN_NOTICE;
> 
> 	...
> 
> 	dev_printk(level, &dev->dev, etc...);
> 
> Maybe do this after this series of patches is accepted.
> Enough with the revisions for awhile...

Hi Joe,

The reason I did it this way was I was trying to be consistent with what was done for the AER interrupt case.  The function aer_print_error()in the same file uses sprintf this way.  I'm not sure why they chose that instead of dev_printk.  I think if we did make the change we should do it in both places to keep them the same.  

Lance
