Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1FURxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:53:11 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:62830 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab1FURxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:53:07 -0400
X-IronPort-AV: E=Sophos;i="4.65,402,1304294400"; 
   d="scan'208";a="6409317"
Date: Tue, 21 Jun 2011 18:57:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [PATCH 1/3] x86: calculate precisely the memory needed by
 init_memory_mapping
In-Reply-To: <4DFFCBAD.9040507@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1106211601570.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop> <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com> <4DFFCBAD.9040507@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, H. Peter Anvin wrote:
> On 06/07/2011 11:13 AM, stefano.stabellini@eu.citrix.com wrote:
> > 
> > - remove the extra page added on x86_32 for the fixmap because is not
> > needed: the PMD entry is already allocated and contiguous for the whole
> > range (a PMD page covers 4G of virtual addresses) and the pte entry is
> > already allocated by early_ioremap_init.
> > 
> 
> Hi Stefano,
> 
> I think this is wrong.  A PMD page covers *1G* of virtual addresses, and
> in the 2+2 and 1+3 memory configurations, we may or may not need a
> separate PMD for the fixmap.
> 
> Am I missing something?

You are right, a PMD page covers 1G of virtual addresses so that part of
the explanation in the comment is wrong.

The reason why we don't need a separate PMD for the fixmap is that in
both PAE and non-PAE cases the last gigabyte of virtual addresses is
always covered by the initial allocation in head_32.S (swapper_pg_dir or
initial_pg_pmd).
