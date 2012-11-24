Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab2KXNEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 08:04:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2KXNEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 08:04:23 -0500
Date: Sat, 24 Nov 2012 13:04:19 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] balancenuma: add stats for huge pmd numa faults
Message-ID: <20121124130419.GA8218@suse.de>
References: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 12:17:03PM +0800, Hillf Danton wrote:
> A thp contributes 512 times more than a regular page to numa fault stats,
> so deserves its own vm event counter. THP migration is also accounted.
> 

I agree and mentioned it needed fixing. I did not create a new counter
but I properly account for PGMIGRATE_SUCCESS and PGMIGRATE_FAIL now. I
did not create a new NUMA_PAGE_MIGRATE counter because I didn't feel it
was necessary. Instead I just do this

        count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
        count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);

> [A duplicated computation of page node idx is cleaned up]
> 

Got it. Thanks

-- 
Mel Gorman
SUSE Labs
