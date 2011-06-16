Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1FPHvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:51:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42031 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1FPHvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uOqDaVEN4SiiVbIwksxf5MgkjQYW89mMIG0F4T5pufb0uODFIAIOwj2fAGuOXH4/ym
         u5W/xMpTOi9NEsEWfymN71zsJg/Ji00krG0px2JSzg5zkJDYXCi0W5MAZCRdH0qe/I51
         gyQohz4NfVdMHnGEy9xlWh4W7G1QJ/x3d0d78=
Date: Thu, 16 Jun 2011 09:51:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, jgarzik@pobox.com,
        mbizon@freebox.fr, benh@kernel.crashing.org, wayneb@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: libata/ipr/powerpc: regression between 2.6.39-rc4 and 2.6.39-rc5
Message-ID: <20110616075114.GH8141@htj.dyndns.org>
References: <20110615191747.GA6324@us.ibm.com>
 <4DF90FCA.1040706@linux.vnet.ibm.com>
 <20110615233417.GB6324@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615233417.GB6324@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 04:34:17PM -0700, Nishanth Aravamudan wrote:
> > That looks like the right thing to do. For ipr's usage of
> > libata, we don't have the concept of a port frozen state, so this flag
> > should really never get set. The alternate way to fix this would be to
> > only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
> > is not NULL.
> 
> It seemed like ipr is as you say, but I wasn't sure if it was
> appropriate to make the change above in the common libata-scis code or
> not. I don't want to break some other device on accident.
> 
> Also, I tried your suggestion, but I don't think that can happen in
> ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
> ap->ops typically gets set only after ata_port_alloc returns?

Maybe we can test error_handler in ata_sas_port_start()?

Thanks.

-- 
tejun
