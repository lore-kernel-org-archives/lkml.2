Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2HAKwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:52:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17571 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2HAKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:52:01 -0400
Date: Wed, 1 Aug 2012 06:42:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 01/24] arm: initial Xen support
Message-ID: <20120801104237.GB7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120726163020.GB9222@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207271246080.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271246080.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +struct pvclock_wall_clock {
> > > +	u32   version;
> > > +	u32   sec;
> > > +	u32   nsec;
> > > +} __attribute__((__packed__));
> > 
> > That is weird. It is 4+4+4 = 12 bytes? Don't you want it to be 16 bytes?
> 
> I agree that 16 bytes would be a better choice, but it needs to match
> the struct in Xen that is defined as follow:
> 
>     uint32_t wc_version;      /* Version counter: see vcpu_time_info_t. */
>     uint32_t wc_sec;          /* Secs  00:00:00 UTC, Jan 1, 1970.  */
>     uint32_t wc_nsec;         /* Nsecs 00:00:00 UTC, Jan 1, 1970.  */

Would it make sense to add some paddigin then at least? In both
cases? Or is it too late for this?
