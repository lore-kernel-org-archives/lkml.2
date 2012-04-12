Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2DLEJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DLEJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:09:00 -0400
Date: Wed, 11 Apr 2012 23:03:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/2] kvm: unmap pages from the iommu when slots are
 removed
Message-ID: <20120412020357.GB3037@amt.cnet>
References: <20120411154536.13227.10413.stgit@bling.home>
 <20120411155149.13227.85904.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411155149.13227.85904.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:51:49AM -0600, Alex Williamson wrote:
> We've been adding new mappings, but not destroying old mappings.
> This can lead to a page leak as pages are pinned using
> get_user_pages, but only unpinned with put_page if they still
> exist in the memslots list on vm shutdown.  A memslot that is
> destroyed while an iommu domain is enabled for the guest will
> therefore result in an elevated page reference count that is
> never cleared.
> 
> Additionally, without this fix, the iommu is only programmed
> with the first translation for a gpa.  This can result in
> peer-to-peer errors if a mapping is destroyed and replaced by a
> new mapping at the same gpa as the iommu will still be pointing
> to the original, pinned memory address.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

