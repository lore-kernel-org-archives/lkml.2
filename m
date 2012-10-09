Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2JIOPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:15:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:5204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2JIOPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154163642"
Message-ID: <50743166.2050900@zytor.com>
Date: Tue, 09 Oct 2012 22:15:02 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve logic
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <1349757558-10856-9-git-send-email-yinghai@kernel.org> <5073C05E.5020402@zytor.com> <CAE9FiQXa9fqLOyqzap6o_0HA=oBRKqkcWm9bdpK9M6R5cQMU-A@mail.gmail.com> <5073D0C1.4020606@zytor.com> <alpine.DEB.2.02.1210091240300.29539@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1210091240300.29539@kaball.uk.xensource.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 08:22 PM, Stefano Stabellini wrote:
> 
> I can give some hints: find_early_table_space allocates more memory than
> needed for pagetable pages, the allocated range is
> pgt_buf_start-pgt_buf_top.
> 

This is why I keep telling you that we should *get rid of*
find_early_table_space and instead build the page tables incrementally.
 There simply is no sane way to make find_early_table_space or anything
else that requires pre-calculating the page table sizes to work and be
robust.

	-hpa

