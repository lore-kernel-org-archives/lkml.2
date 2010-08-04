Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab0HDVYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:24:21 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:49507 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759089Ab0HDVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:24:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pCen0gnRzWs98skDnhSdN+L1n3oPVwdzSCG28joRmTlDbIy4s6Ek+/hjCnug44SyQulgTKsLtqxESWXUltdvASCCNuTsox9G+PUF0wBtm9Ci2+SXXFWr9hNMN3L5ElLq;
Date: Wed, 4 Aug 2010 14:24:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Narendra K <Narendra_K@dell.com>,
        Jordan Hargrave <jordan_hargrave@dell.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100804142412.429e6b06@virtuousgeek.org>
In-Reply-To: <20100804142531.aea95c0b.sfr@canb.auug.org.au>
References: <20100804142531.aea95c0b.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 14:25:31 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/pci/pci-label.c:100: error: unknown field 'owner' specified in initializer
> drivers/pci/pci-label.c:100: warning: initialization from incompatible pointer type
> drivers/pci/pci-label.c:105: error: unknown field 'owner' specified in initializer
> drivers/pci/pci-label.c:105: warning: initialization from incompatible pointer type
> 
> Caused by commit 60cc62ad579afa0eb5bded82e08dd0617d461d52 ("sysfs: Remove
> owner field from sysfs struct attribute") interacting with commit
> 911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI: export SMBIOS provided
> firmware instance and label to sysfs") from the pci tree.
> 
> I applied the following merge fix patch (Jesse, this patch can already be
> applied to the pci tree without problems):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 4 Aug 2010 14:21:42 +1000
> Subject: [PATCH] pci: update for owner removal from struct device_attribute
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
