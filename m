Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0LVIuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:50:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24994 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab0LVIut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:50:49 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2010 03:50:49 EST
X-IronPort-AV: E=Sophos;i="4.60,212,1291611600"; 
   d="scan'208";a="11652616"
Subject: Re: [Xen-devel] Re: [PATCH 01/10] xen: Make all reserved pages for
 the balloon be INVALID_P2M_ENTRY.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <4D1127FC.8060102@goop.org>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1292967460-15709-2-git-send-email-konrad.wilk@oracle.com>
	 <4D1127FC.8060102@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 08:47:10 +0000
Message-ID: <1293007630.3998.36.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 22:19 +0000, Jeremy Fitzhardinge wrote: 
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > +		BUG_ON(!set_phys_to_machine(pfn, INVALID_P2M_ENTRY));
[...] 
> I'm not a fan of hiding real side-effectful code in a BUG_ON
> predicate.
> 
> > +		BUG_ON(get_phys_to_machine(pfn) != INVALID_P2M_ENTRY);

I'm also not a fan of this "is the previous I called function buggy"
BUG_ON.

If we aren't confident that set_phys_to_machine() is doing the right
thing then adding a post-condition check to that function would be a
more preferable option.

Ian.


