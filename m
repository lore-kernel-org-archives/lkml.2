Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1EXK6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:58:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:50144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1EXK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:58:23 -0400
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during hotplug
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 May 2011 11:58:15 +0100
In-Reply-To: <1305843308.3100.10.camel@x201>
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306234696.7218.14.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 16:15 -0600, Alex Williamson wrote:
> I think I'd vote for saving some kind of representation of the bus
> hierarchy, we probably don't need to list every possible individual
> device.  Leaving a broken pointer around to be matched up and restored
> later just seems like a continuation of an idea that was bad to begin
> with.  Thanks, 

I agree. We should just process the original ATSR information in
dmar_find_matched_drhd_unit(), rather than comparing with a list of
possibly stale pointers.

I don't quite understand why the list of PCI devices was *ever* done
like that.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

