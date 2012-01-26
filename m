Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2AZRYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:24:23 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45873 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2AZRYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:24:21 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275bh8275dhz2fhc1bhc31hc1ah2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM25aksotK5RCq0022C1tEJ6xUZZYfa5IA//97SjA=
Date: Thu, 26 Jan 2012 17:24:03 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B6FE61C@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1327516187-21793-1-git-send-email-kys@microsoft.com>
 <4414328.OlPOtXe4lZ@eto>
In-Reply-To: <4414328.OlPOtXe4lZ@eto>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de]
> Sent: Thursday, January 26, 2012 12:17 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> Am Mittwoch 25 Januar 2012, 10:29:47 schrieb K. Y. Srinivasan:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> >
> > This patch is based on the storvsc patches that are already on Greg's queue
> > for the staging tree. This patch-set addressed Christoph's review comments.
> > If need be, I can re-send this patch-set in Greg's queue
> > or I can  send the fully patched storvsc_drv.c.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/Kconfig                       |    7 +++++++
> >  drivers/scsi/Makefile                      |    3 +++
> >  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
> >  3 files changed, 10 insertions(+), 0 deletions(-)
> >  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
> >
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 16570aa..d3d18e8 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -662,6 +662,13 @@ config VMWARE_PVSCSI
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called vmw_pvscsi.
> >
> > +config HYPERV_STORAGE
> > +	tristate "Microsoft Hyper-V virtual storage driver"
> > +	depends on SCSI && HYPERV
> > +	default HYPERV
> > +	help
> > +	  Select this option to enable the Hyper-V virtual storage driver.
> > +
> >  config LIBFC
> >  	tristate "LibFC module"
> >  	select SCSI_FC_ATTRS
> > diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> > index 2b88749..e4c1a69 100644
> 
> I still miss a "this driver will be called ..." message here, as it is used
> e.g. by the entry before:

After I moved the file to the scsi directory, in my haste I forgot to git add
the file. Sorry for the confusion; I will send out the corrected patches soon.

Regards,

K. Y


