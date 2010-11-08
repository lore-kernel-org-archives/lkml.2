Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0KHQgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:36:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42747 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0KHQgH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 8 Nov 2010 11:36:07 -0500
Date: Mon, 8 Nov 2010 11:34:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Milton Miller <miltonm@bga.com>
Cc: Jiri Slaby <jslaby@suse.cz>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] PCI: xen-pcifront, fix PCI reference leak
Message-ID: <20101108163411.GA2638@dumpdata.com>
References: <1288881090-27335-1-git-send-email-jslaby@suse.cz>
 <xenfront-reffix-fixreq@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xenfront-reffix-fixreq@mdm.bga.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 12:27:07PM -0600, Milton Miller wrote:
> On 2010-11-04 at about 14:31:30 Jiri Slaby wrote:
> > Stanse found that when pdev is found and has no driver a reference is
> > leaked in pcifront_common_process. So add pci_dev_put there. For the
> > pdev == NULL case, pci_dev_put(NULL) is fine.
> 
> While that may be true, the dev_err(&pcidev->dev ... is a NULL pointer
> deref.

I've put the fix in the branch (stable/xen-pcifront-fixes) that I will ask Linus
to pull.. but what options did you need to find this?

I tried to run this before putting your and Milton fix in:
konrad@phenom:~/tar/stanse-1.1.2$ java -jar ./stanse.jar  ~/work/linux/drivers/pci/xen-pcifront.c 
Stanse version "1.1.2"
Copyright (c) 2008-2010 Masaryk University, Brno

STANSE_HOME not specified. Using the location of stanse.jar.
Checking for bugs:
<-> File: /home/konrad/work/linux/drivers/pci/xen-pcifront.c
<-> --------------------------------
Done.

And no warnings?
