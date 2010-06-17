Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab0FQPoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:44:19 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59730 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0FQPoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:44:15 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="462504"
Date: Thu, 17 Jun 2010 16:42:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 05/12] Add suspend\resume support for PV on
 HVM guests.
In-Reply-To: <20100614212033.GB8600@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006171635150.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-5-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212033.GB8600@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > +static int platform_pci_resume(struct pci_dev *pdev)
> > +{
> > +	int err;
> > +	if (xen_have_vector_callback)
> > +		return 0;
> > +	err = xen_set_callback_via(callback_via);
> > +	if (err) {
> > +		printk("platform_pci_resume failure!\n");
> 
> How did you scripts/checkpatch.pl --strict let you do that?
> You might want to use dev_err instead.
> 

I'll do that and re-run checkpatch.pl on the whole series

