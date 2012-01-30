Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2A3DTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:19:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33716 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2A3DTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:19:04 -0500
Date: Mon, 30 Jan 2012 11:18:45 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] pci: check for 4k resource_size alignment in
 sriov_init
Message-ID: <20120130031845.GA2359@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20120127191032.GA22999@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127191032.GA22999@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013003-5518-0000-0000-000001DF23BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 12:40:32AM +0530, Vaidyanathan Srinivasan wrote:
> Hi Ram and Jesse,
> 
> I found a trivial issue with page size alignment check on IBM POWER
> box with 64k base page size.  In sriov_init(), changing the check from
> PAGE_SIZE (arch and config dependent) to HW_PAGE_SIZE (always 4k) was
> required to use one of the sriov adapter as PF since the
> resource_size() comes up as 0x8000 and PAGE_SIZE would be 0x10000 for
> pseries boxes.
> 
> I think resource_size() could be less than SystemPageSize, but I would
> like your comments/ack/nack on any consequences of checking for only
> 4k alignment here in a system with larger base page size.

As per the SRIOV specs, the  resource has to be System page size aligned.

PFs are required to support 4-KB, 8-KB, 64-KB, 256-KB, 1-MB, and 4-MB
page sizes. In your case if your adapter's PF is not supporting 64K page size
then I think it is not conforming to the PCI SRIOV spec.

RP

