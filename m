Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2KHRye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:54:34 -0500
Received: from xes-mad.com ([216.165.139.218]:35873 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2KHRyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:54:33 -0500
X-Greylist: delayed 2972 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 12:54:32 EST
Date: Thu, 08 Nov 2012 11:04:54 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers: mfd: Fix resource request for [mem 0x00000000]
Message-ID: <cd909a40-1ba3-471e-b6c4-b54432a626df@zimbra>
In-Reply-To: <1352343356-4006-6-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The older southbridges supported by the lpc_ich driver do not
> provide memory-mapped space of the root complex. The driver
> correctly avoids computing the iomem address in this case, yet
> submits a zeroed resource request anyway (via mfd_add_devices()).
> 
> Remove the iomem resource from the resource array submitted to the
> mfd core for the older southbridges.
> 

Peter, thanks for catching this.

> +	} else {
> +		/* So don't register iomem for TCO ver 1 */
> +		--lpc_ich_cells[LPC_WDT].num_resources;

My only complaint is that pre-decrementing num_resources isn't
necessary and doesn't match the other cases where num_resources is
decremented (post-decremented), like here:

        if (!base_addr) {
                dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
                lpc_ich_cells[LPC_GPIO].num_resources--;
                goto gpe0_done;
        }

-Aaron
