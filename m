Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1ADRTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:19:04 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49637 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1ADRTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:19:01 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="129534215"
Subject: Re: [PATCH 3/8] xen/setup: Set identity mapping for non-RAM E820
 and E820 gaps.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1293738517-7287-4-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 17:18:58 +0000
Message-ID: <1294161538.3831.639.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> We walk the E820 region and start at 0 (for PV guests we start
> at ISA_END_ADDRESS)

I was trying to figure out what any of this had to do with HVM guests,
but you mean as opposed to dom0, which with my pedant hat on is also a
guest ;-).

>  and skip any E820 RAM regions. For all other
> regions and as well the gaps we set them to be identity mappings.
> 
> The reasons we do not want to set the identity mapping from 0->
> ISA_END_ADDRESS when running as PV is b/c that the kernel would
> try to read DMI information and fail (no permissions to read that).

The reason for this special case is that in domU we have already punched
a hole from 640k-1M into the e820 which the hypervisor gave us.

Should we perhaps be doing this identity mapping before we punch that
extra hole? i.e. setup ID mappings based on the hypervisors idea of the
guest e820 not the munged one we subsequently magicked up? Only the
original e820 is going to bear any possible resemblance to the identity
pages which the guest can actually see.

Ian.


