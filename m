Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0LVPKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:10:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42734 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0LVPKv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:10:51 -0500
Date: Wed, 22 Dec 2010 10:10:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 07/10] xen/mmu: Work with 1-1 mappings when allocating
 new top/middle entries.
Message-ID: <20101222151040.GH1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
 <4D112C3A.6080500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112C3A.6080500@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:37:46PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > We were not properly taking under advisement the 1-1 mappings
> > when a large area of memory was ballooned out.
> 
> Could you expand on this?  What does it mean?

The balloon code was going from the end of its region down, and those
regions were in the p2m_missing (and p2m_mid_missing) zone. Which is
correct, except that the alloc_p2m did not  know how to handle this.

So it never actually allocated the middle or entry level pages
which would contain the newly added PFNs.

I've rolled this patch in the 
    xen/mmu: Add the notion of identity (1-1) mapping.

patch soon to be posted.
