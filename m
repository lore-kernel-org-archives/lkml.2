Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2DSLnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2DSLnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:43:31 -0400
Date: Thu, 19 Apr 2012 00:04:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jbaron@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] kvm: lock slots_lock around device assignment
Message-ID: <20120419030432.GA23261@amt.cnet>
References: <20120418034537.26262.80743.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418034537.26262.80743.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:46:44PM -0600, Alex Williamson wrote:
> As pointed out by Jason Baron, when assigning a device to a guest
> we first set the iommu domain pointer, which enables mapping
> and unmapping of memory slots to the iommu.  This leaves a window
> where this path is enabled, but we haven't synchronized the iommu
> mappings to the existing memory slots.  Thus a slot being removed
> at that point could send us down unexpected code paths removing
> non-existent pinnings and iommu mappings.  Take the slots_lock
> around creating the iommu domain and initial mappings as well as
> around iommu teardown to avoid this race.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

