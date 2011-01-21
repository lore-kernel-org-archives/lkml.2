Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1AUQU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:20:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58761 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1AUQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:20:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X5av/gZxMCCRzA8hC33jaVQOy1F3mma+RsSlP70rvrpkXuTO0IfrYUZi9xFpJma6QV
         HjC8yG9SHLShhYmKVwy30F9n9SrwzllzNnYMJc82Wp7gu3z/C5L+BDjt+4zBCiI2hoCa
         rIhC8TdxWZwg7K8WPOiK/POYeGPtFDJYfFSQA=
Subject: RE: Status of the LSI 2108
From: James Shubin <purpleidea@gmail.com>
Reply-To: purpleidea@gmail.com
To: support@supermicro.com
In-Reply-To: <D41A5B864986B546A595D85C4701A9C001023A5A4E@cosmail03.lsi.com>
References: <1295411153.20086.81.camel@localhost>
	 <20110120153419.806d38e1.rdunlap@xenotime.net>
	 <1295567826.20086.89.camel@localhost>
	 <D41A5B864986B546A595D85C4701A9C001023A5A4E@cosmail03.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 11:20:35 -0500
Message-ID: <1295626835.20086.131.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Supermicro,

I'm looking for information on whether the LSI 2108 is fully supported
in the vanilla linux kernel, and any thoughts as to the quality/
robustness of the driver. The servers in question that I'm interested in
are the:
http://www.supermicro.com/products/system/2U/8026/SYS-8026B-6R.cfm?SAS=Y

Thank you for your time, feel free to see the below history for some
background.

James


On Fri, 2011-01-21 at 08:47 -0700, Unrein, Jason wrote:
> The latest vanilla kernel should have support for all of our second generation sas HBAs (6gb/s capable).  If there are any problems you can always download an updated driver from the www.lsi.com website.  
> 
> The Supermicro ftp site you sent is actually for our counterpart in LSI, Megaraid.  Since they run a different firmware, they have a different driver in the kernel (megaraid_sas) where as ours are mptlinux (Gen1, 3.0gb/s), mpt2sas (Gen2), mpt2sasbtm (Gen2 but for older 2.6 kernels).  We both use the same chip so Supermicro might be making it a little confusing.  You might see if they reference the chip as a Megaraid chip in any way or if it is always an LSI chip. It is possible to run it in both modes if all the hardware components are there.
> 
> It would probably be best to email Supermicro and get the details from them about the chip to confirm what you need.
> 
> -----Original Message-----
> From: James Shubin [mailto:purpleidea@gmail.com] 
> Sent: Thursday, January 20, 2011 5:57 PM
> To: Randy Dunlap
> Cc: scsi; linux-kernel@vger.kernel.org; DL-MPT Fusion Linux
> Subject: Re: Status of the LSI 2108
> 
> Thanks Randy for sending me in the right direction.
> Hello linux-scsi and LSI. Any thoughts to the below question would be
> much appreciated!
> 
> James
> 
> 
> On Thu, 2011-01-20 at 15:34 -0800, Randy Dunlap wrote:
> > On Tue, 18 Jan 2011 23:25:53 -0500 James Shubin wrote:
> > 
> > > Hi,
> > > 
> > > I've been trying to find out if the LSI 2108 is fully supported in the
> > > vanilla kernel, and any thoughts as to the quality/robustness.
> > > 
> > > This seems to be the correct source:
> > > ftp://ftp.supermicro.nl/driver/SAS/LSI/2108/Driver/Linux/v04.31/
> > > however I'm not sure at all if it's maintained, or what. I would
> > > outright test this myself, however I haven't bought the servers yet
> > > 
> > > Thanks for your help,
> > > Please cc-me on replies.
> > 
> > Hi,
> > 
> > Probably better to ask on the linux-scsi mailing list [added].
> > Also added the lsi.com email address.
> > 
> > 
> > drivers/scsi/mpt2sas/mpt2sas_scsih.c contains this:
> > 
> > 	/* Liberator ~ 2108 */
> > 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_1,
> > 		PCI_ANY_ID, PCI_ANY_ID },
> > 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_2,
> > 		PCI_ANY_ID, PCI_ANY_ID },
> > 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
> > 		PCI_ANY_ID, PCI_ANY_ID },
> > 
> > so it looks like there is at least some basic support for the 2108.
> > 
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> 


