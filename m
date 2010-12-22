Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0LVPNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:13:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52309 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0LVPNO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:13:14 -0500
Date: Wed, 22 Dec 2010 10:11:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 08/10] xen/mmu: Bugfix. Fill the top entry page with
 appropriate middle layer pointers.
Message-ID: <20101222151115.GI1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-9-git-send-email-konrad.wilk@oracle.com>
 <4D112C66.9040600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112C66.9040600@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:38:30PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > If we swapped over from using an p2m_mid_identical to p2m_mid_missing
> > (earlier call to set_phys_to_machine) and then started going through the
> > PFNs in descending order to program a new MFN (balloon worker), we would
> > end up in this code path. At that point we would set up new page filled with
> > pointers to p2m_identity instead of p2m_missing. This had the disastrous
> > effect that get_phys_to_machine on that PFN would return an 1-1 mapping
> > instead of INVALID_P2M_ENTRY resulting in hitting a BUG check in balloon driver.
> >
> Are you going to fold this into the appropriate patch later?

Yes. Rolled it in 
    xen/mmu: Add the notion of identity (1-1) mapping.

