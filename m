Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0LWVXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:23:15 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53992 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LWVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:23:14 -0500
Subject: Re: [PATCH 00/12] LLD host_lock-less conversion status for .38
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
In-Reply-To: <AANLkTi=+QhTdWFEtu9UD9AJC_N+UET8i+7F_qzOS5Znt@mail.gmail.com>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTi=+QhTdWFEtu9UD9AJC_N+UET8i+7F_qzOS5Znt@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 23 Dec 2010 13:17:18 -0800
Message-Id: <1293139038.4649.117.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 11:33 -0800, adam radford wrote:
> On Sun, Dec 19, 2010 at 1:21 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > *) megaraid_sas: Running in host_lock-less mode with MSI-X interrupts
> >
> > This has not been tested yet, but I would like to get some review from the LSI
> > megaraid_sas folks now that their patches to enable MSI-X interrupts has been sent
> > to linux-scsi.
> >
> > AdamR, any thoughts or comments to add here..?
> 
> Nick,
> 
> Your patch will not work with the new MegaRAID adapter support I have
> sent in recently.  It requires the build IO path be synchronized with
> map updates with the host_lock.
> 

Adam,

Thanks for the clarification wrt to your latest patches.  Do you think
it would make sense to convert the synchronization between the build IO
path and map updates to use the LLD specific instance->hba_lock instead
of host_lock..?  This is the method I have been employing thus far w/
with the host_lock-less conversion for megaraid_sas, and from a quick
grok it appears this might be the most sane approach for MSI-X support.

Any thoughts..?

Best Regards,

--nab

