Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2EURsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:48:30 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19006 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab2EURsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:48:01 -0400
X-IronPort-AV: E=Sophos;i="4.75,632,1330905600"; 
   d="scan'208";a="12586866"
Date: Mon, 21 May 2012 18:47:44 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: do not map the same GSI twice
In-Reply-To: <20120521172703.GA9988@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1205211846510.26786@kaball-desktop>
References: <1337615650-27911-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120521172703.GA9988@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, May 21, 2012 at 04:54:10PM +0100, Stefano Stabellini wrote:
> > PV on HVM guests map GSIs into event channels; at restore time the
> > event channels are resumed by restore_pirqs.
> > Device drivers might try to register the same GSI again through ACPI at
> > restore time, but the GSI has already been mapped and bound by
> > restore_pirqs.
> 
> Which means... what kind of error do we get without this patch?

Xen would print:

(XEN) irq.c:2235: dom4: pirq 23 or emuirq 28 already mapped

and waste a pirq
