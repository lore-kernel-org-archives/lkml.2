Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1HIJaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:30:16 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:25233 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1HIJaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:30:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjC0PECMV
X-RZG-CLASS-ID: mo00
Date: Tue, 9 Aug 2011 11:29:38 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to
 existing eventchannel ports
Message-ID: <20110809092938.GB7283@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
 <20110804162054.510901329@aepfle.de>
 <1312881460.26263.46.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312881460.26263.46.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, Ian Campbell wrote:

> On Thu, 2011-08-04 at 17:20 +0100, Olaf Hering wrote:
> > During a kexec boot some virqs such as timer and debugirq were already
> > registered by the old kernel.  The hypervisor will return -EEXISTS from
> > the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
> > triggers.  Catch the -EEXISTS error and loop through all possible ports to find
> > what port belongs to the virq/cpu combo.
> 
> Would it be better to proactively just query the status of all event
> channels early on, like you do in find_virq, and setup the irq info
> structures as appropriate? Rather than waiting for an -EEXISTS I mean.

Doing one hypercall in the common case is cheaper than doing a dozen in
the kexec case.

If you prefer I will rearrange this part and query first.

Olaf
