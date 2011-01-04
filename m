Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1ADSr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:47:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58213 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1ADSr4 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 Jan 2011 13:47:56 -0500
Date: Tue, 4 Jan 2011 13:46:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP
 flag set.
Message-ID: <20110104184604.GB1505@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
 <1293738517-7287-7-git-send-email-konrad.wilk@oracle.com>
 <1294161878.3831.654.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294161878.3831.654.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 05:24:38PM +0000, Ian Campbell wrote:
> On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > Only enabled if XEN_DEBUG_FS is enabled.
> 
> Bit of an odd configuration option to use. Perhaps co-opt
> CONFIG_PARAVIRT_DEBUG instead?
> 
> Or maybe we need a new XEN_DEBUG option? or just make it a developer
> only EXTRA_CFLAGS +=-DDEBUG thing?

I think the 'XEN_DEBUG' works better.
> 
> Is this only temporary until the need for _PAGE_IOMAP is removed anyway?

I was thinking to leave it as a way to weed out bugs, but I could as well
just leave it in my "debug" branch and not propose it upstream.

I am not sure how to remove the _PAGE_IOMAP fully. We need some _flag_ to
signal 'xen_pte_val' that the PTE should not be looked up in the M2P.

Otherwise, for identity mappings, the value is 0xfffff.. (or 0x55555.. sometimes)
and the PTE ends up being messed up. Instead there is a check to see if
_PAGE_IOMAP is part of the PTE, and if so, no M2P lookup is done.

I guess we could do the M2P irregardless and just see if it is 0xfffff... and
if so just return the PTE without any changes.

> 
> Ian.
> 
