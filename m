Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab2EUR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:58:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40426 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab2EUR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:58:17 -0400
Date: Mon, 21 May 2012 13:51:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: do not map the same GSI twice
Message-ID: <20120521175142.GA13990@phenom.dumpdata.com>
References: <1337615650-27911-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120521172703.GA9988@phenom.dumpdata.com>
 <alpine.DEB.2.00.1205211846510.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205211846510.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:47:44PM +0100, Stefano Stabellini wrote:
> On Mon, 21 May 2012, Konrad Rzeszutek Wilk wrote:
> > On Mon, May 21, 2012 at 04:54:10PM +0100, Stefano Stabellini wrote:
> > > PV on HVM guests map GSIs into event channels; at restore time the
> > > event channels are resumed by restore_pirqs.
> > > Device drivers might try to register the same GSI again through ACPI at
> > > restore time, but the GSI has already been mapped and bound by
> > > restore_pirqs.
> > 
> > Which means... what kind of error do we get without this patch?
> 
> Xen would print:
> 
> (XEN) irq.c:2235: dom4: pirq 23 or emuirq 28 already mapped
> 
> and waste a pirq

OK. This sounds like it has been a bug since ..oh forever then?
