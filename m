Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1DMS2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:28:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:6242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1DMS2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,205,1301900400"; 
   d="scan'208";a="909126811"
Message-ID: <4DA5EB46.6090302@linux.intel.com>
Date: Wed, 13 Apr 2011 11:28:22 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA48EA9.70109@kernel.org> <alpine.DEB.2.00.1104131125080.22672@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1104131125080.22672@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 03:35 AM, Stefano Stabellini wrote:
> Yes, that would be ideal, but we cannot do that because we don't know
> exactly where is pgt_buf_end before allocating the pagetable pages and
> the pagetable pages need to be marked RO before being hooked into the
> pagetable. This is why we mark the whole range RO and after the
> pagetable allocation when we know for sure where is pgt_buf_end we
> modify the range pgt_buf_end-pgt_buf_top to RW.

The hell?  You have to fill the pages before you hook them into the page
tables anyway (this means writing!) and then you have to mark them RO as
you add them to the page tables... anything else doesn't make any sense
at all.

	-hpa
