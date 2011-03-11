Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1CKAkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:40:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33795 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1CKAkA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 19:40:00 -0500
Date: Thu, 10 Mar 2011 19:38:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [GIT PATCH v2 0/14] xen: events: cleanups +
 ween off nr_irqs
Message-ID: <20110311003841.GA3063@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
 <20110310225726.GA2983@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310225726.GA2983@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D796F58.009C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am having difficulties with passthrough of an USB device. Somehow the
> irq count is not going up at all (both in dom0 and domU) and it looks to
> be doing just simple polling. I've rebased the xen-pciback to be on top
> of your changes and apply cleanly. The whole lot is now in #master

I think your patchset breaks the 'xc_physdev_map_pirq' call. Looks like
libxl_pci.c reads from /sys/bus/pci/devices/<BDF>/irq to figure out what value
to pass. With these patches we wouldn't neccessarily pass in the right
PIRQ value. Any ideas?

