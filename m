Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1FTWiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:38:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:52060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1FTWiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,396,1304319600"; 
   d="scan'208";a="15826019"
Message-ID: <4DFFCBAD.9040507@linux.intel.com>
Date: Mon, 20 Jun 2011 15:37:33 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: hpa@zytor.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        yinghai@kernel.org
Subject: Re: [PATCH 1/3] x86: calculate precisely the memory needed by init_memory_mapping
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop> <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 11:13 AM, stefano.stabellini@eu.citrix.com wrote:
> 
> - remove the extra page added on x86_32 for the fixmap because is not
> needed: the PMD entry is already allocated and contiguous for the whole
> range (a PMD page covers 4G of virtual addresses) and the pte entry is
> already allocated by early_ioremap_init.
> 

Hi Stefano,

I think this is wrong.  A PMD page covers *1G* of virtual addresses, and
in the 2+2 and 1+3 memory configurations, we may or may not need a
separate PMD for the fixmap.

Am I missing something?

	-hpa
