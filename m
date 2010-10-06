Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab0JFH4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:56:09 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:36997 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757150Ab0JFH4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:56:07 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: xKwxvswVM1mBTMcw9G3bf6NFemFcnsAy_iu3f7HMIt99_Yx
 pHq3Y0rG8SNPhBIS9bD_QpvLskhy60haqSIU5_OULKHlTC6W5o.09k2jUZfs
 udW6IoB3Rls9r.mPLApbvj2dXtp2TB0dxlu_F9qGeMiTqI4q3ZqOIT5Ls_JC
 .j61DchuuSdB0TrTssAaVdeYZP1isIabiRUbNrUOy4w750dkImiTI1pLIetv
 nlFuYuoImdeBmsutDliCMY5ZuHVpgYCkgxT77QdJhJaep9BjoSqJpIBZ5Jn_
 JR1l7hBZ_AkkJrIuqDE0oBJJP1SDNcrzKLNwkeMCVxnR_0gd1_MTjHYdgN_x
 RWbzr5jmxlRKjS_gk7Q--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de,
        James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com,
        joel.becker@oracle.com, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20101006163859Y.fujita.tomonori@lab.ntt.co.jp>
References: <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
	 <20101006155833G.fujita.tomonori@lab.ntt.co.jp>
	 <1286349730.5685.113.camel@haakon2.linux-iscsi.org>
	 <20101006163859Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Wed, 06 Oct 2010 00:51:27 -0700
Message-Id: <1286351487.5685.145.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 16:43 +0900, FUJITA Tomonori wrote:
> On Wed, 06 Oct 2010 00:22:10 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > > > The main issue here is that the user still needs to know the $LPORT_WWPN
> > > > before hand (either from looking at a sticker on the card, or via
> > > > another method) in order to preform the initial TFO->fabric_make_wwn()
> > > > -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
> > > > at the top level TCM fabric group in order to see a list of the
> > > > available hardware ports from the specific $TCM_MOD.  What I was
> > > > thinking for TCM HW fabric module ports would be to have something like:
> > > > 
> > > > 	/sys/kernel/config/target/$TCM_MOD/hw_ports
> > > > 
> > > > that would walk the struct pci_dev looking for fabric module specific HW
> > > > target mode capabilities.  I assume this is what you had in mind for
> > > > drivers/scsi/ibmvscsi as well, yes..?
> > > 
> > > Doesn't sound so.
> > > 
> > > I want the driver to create necessary target directories in
> > > /sys/kernel/config/target/ibmvscsit/ automatically.
> > > 
> > > 
> > 
> > Hmmmm, well configfs is entirely driven by userspace syscalls, so we
> 
> I think that we really want to configure things by kernel space too
> because the scsi target stuff need to handle hardware.
> 
> Need to load the module and create the module name directory by name?
> 
> Need to read the content in sysfs to get the hardware info and create
> the directories appropriate for the hardware by hand?
> 
> Looks strange and inconvenient interface to me. Why can't the kernel
> just create the directory layout that suits to the hardware for users?
> 
> 

Actually, I already had some code that could simulate mkdir(2) and
rmdir(2) to do exactly what you are talking about here for doing
configfs groups ops from kernel space in 2008 in to assist with the
IOCTL -> configfs v3.0 conversion work.  Joel gave this a big NACK back
then, and I removed the code from target_core_configfs.c shortly
thereafter.  

But really, pushing this logic into userspace and making
python/perl/shell code do these type of things IMHO makes the kernel
level target code cleaner.

Of course I think having something to create configfs groups from
kernelspace is very useful for debugging and ProcFS/SysFS/NetLink/IOCTL
-> ConfigFS conversion purposes, but I will have to defer to Joel for
his reasons of not allowing configfs consumers to do this. (CC'ing
linux-fsdevel)

--nab

