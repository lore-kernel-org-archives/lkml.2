Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1ADTV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:21:27 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34609 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1ADTVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:21:25 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="129553175"
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP
 flag set.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110104184604.GB1505@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-7-git-send-email-konrad.wilk@oracle.com>
	 <1294161878.3831.654.camel@zakaz.uk.xensource.com>
	 <20110104184604.GB1505@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 19:20:56 +0000
Message-ID: <1294168856.3582.16.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 18:46 +0000, Konrad Rzeszutek Wilk wrote: 
> On Tue, Jan 04, 2011 at 05:24:38PM +0000, Ian Campbell wrote:
> > On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > > Only enabled if XEN_DEBUG_FS is enabled.
> > 
> > Bit of an odd configuration option to use. Perhaps co-opt
> > CONFIG_PARAVIRT_DEBUG instead?
> > 
> > Or maybe we need a new XEN_DEBUG option? or just make it a developer
> > only EXTRA_CFLAGS +=-DDEBUG thing?
> 
> I think the 'XEN_DEBUG' works better.
> > 
> > Is this only temporary until the need for _PAGE_IOMAP is removed anyway?
> 
> I was thinking to leave it as a way to weed out bugs, but I could as well
> just leave it in my "debug" branch and not propose it upstream.
> 
> I am not sure how to remove the _PAGE_IOMAP fully. We need some _flag_ to
> signal 'xen_pte_val' that the PTE should not be looked up in the M2P.
> 
> Otherwise, for identity mappings, the value is 0xfffff.. (or 0x55555.. sometimes)
> and the PTE ends up being messed up. Instead there is a check to see if
> _PAGE_IOMAP is part of the PTE, and if so, no M2P lookup is done.
> 
> I guess we could do the M2P irregardless and just see if it is 0xfffff... and
> if so just return the PTE without any changes.

Perhaps this ties in with the m2p overlay which Stefano+Jeremy have been
working on to deal with granted foreign pages? I/O pages are a bit like
foreign memory (if you squint enough)...

Ian.

