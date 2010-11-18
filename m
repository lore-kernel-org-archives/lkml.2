Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab0KRXnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:43:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50951 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0KRXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:43:21 -0500
Date: Thu, 18 Nov 2010 15:42:16 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, mfasheh@suse.com
Subject: Re: fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-ID: <20101118234216.GH19821@mail.oracle.com>
Mail-Followup-To: David Sterba <dsterba@suse.cz>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	mfasheh@suse.com
References: <20101102223601.GA27513@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102223601.GA27513@ds.suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 11:36:02PM +0100, David Sterba wrote:
> coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
> in fs/ocfs2/dlm/dlmdomain.c an allocation with GFP_KERNEL is done
> with locks held:
> 
> dlm_query_region_handler
>   spin_lock(dlm_domain_lock)
>     dlm_match_regions
>       kmalloc(GFP_KERNEL)
> 
> Change it to GFP_ATOMIC.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> CC: Joel Becker <joel.becker@oracle.com>
> CC: Mark Fasheh <mfasheh@suse.com>
> CC: ocfs2-devel@oss.oracle.com

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
