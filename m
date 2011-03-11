Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1CKJRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:17:05 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:55151 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1CKJRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:17:02 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297036800"; 
   d="scan'208";a="4738098"
Subject: Re: [Xen-devel] Re: [GIT PATCH v2 0/14] xen: events: cleanups +
 ween off nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110311003841.GA3063@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
	 <20110310225726.GA2983@dumpdata.com>  <20110311003841.GA3063@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Mar 2011 09:17:00 +0000
Message-ID: <1299835020.17339.1807.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 00:38 +0000, Konrad Rzeszutek Wilk wrote:
> > I am having difficulties with passthrough of an USB device. Somehow the
> > irq count is not going up at all (both in dom0 and domU) and it looks to
> > be doing just simple polling. I've rebased the xen-pciback to be on top
> > of your changes and apply cleanly. The whole lot is now in #master
> 
> I think your patchset breaks the 'xc_physdev_map_pirq' call. Looks like
> libxl_pci.c reads from /sys/bus/pci/devices/<BDF>/irq to figure out what value
> to pass. With these patches we wouldn't neccessarily pass in the right
> PIRQ value. Any ideas?

I'll have to have a think. At best there's some confusing usage of the
term pirq in there. (which is not unexpected, various subsystems use it
for different things.)

Certainly I would never expect to read a Xen pirq out of /sys/.../irq
and that appears to be how this value is being used...

Ian.

