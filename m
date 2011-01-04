Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1ADQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:34:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:4878 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1ADQev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:34:51 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="11773811"
Subject: Re: [PATCH 1/8] xen: Mark all initial reserved pages for the
 balloon as INVALID_P2M_ENTRY.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1293738517-7287-2-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 16:34:48 +0000
Message-ID: <1294158888.3831.509.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> With this patch, we diligently set regions that will be used by the
> balloon driver to be INVALID_P2M_ENTRY and under the ownership
> of the balloon driver. We are OK using the __set_phys_to_machine
> as we do not expect to be allocating any P2M middle or entries pages.

... because xen_build_mfn_list_list will have already allocated all such
pages up to xen_max_p2m_pfn.

(right?)

Ian.


