Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab0FONo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:44:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27885 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0FONoY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Jun 2010 09:44:24 -0400
Date: Mon, 14 Jun 2010 17:20:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 05/12] Add suspend\resume support for PV on
 HVM guests.
Message-ID: <20100614212033.GB8600@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275570645-27189-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4C1783AA.006B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int platform_pci_resume(struct pci_dev *pdev)
> +{
> +	int err;
> +	if (xen_have_vector_callback)
> +		return 0;
> +	err = xen_set_callback_via(callback_via);
> +	if (err) {
> +		printk("platform_pci_resume failure!\n");

How did you scripts/checkpatch.pl --strict let you do that?
You might want to use dev_err instead.

