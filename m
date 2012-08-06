Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2HFK4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:56:03 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11518 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2HFK4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:56:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,718,1336348800"; 
   d="scan'208";a="13863791"
Date: Mon, 6 Aug 2012 11:55:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 01/24] arm: initial Xen support
In-Reply-To: <20120801104237.GB7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208061146480.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120726163020.GB9222@phenom.dumpdata.com> <alpine.DEB.2.02.1207271246080.26163@kaball.uk.xensource.com>
 <20120801104237.GB7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > > +struct pvclock_wall_clock {
> > > > +	u32   version;
> > > > +	u32   sec;
> > > > +	u32   nsec;
> > > > +} __attribute__((__packed__));
> > > 
> > > That is weird. It is 4+4+4 = 12 bytes? Don't you want it to be 16 bytes?
> > 
> > I agree that 16 bytes would be a better choice, but it needs to match
> > the struct in Xen that is defined as follow:
> > 
> >     uint32_t wc_version;      /* Version counter: see vcpu_time_info_t. */
> >     uint32_t wc_sec;          /* Secs  00:00:00 UTC, Jan 1, 1970.  */
> >     uint32_t wc_nsec;         /* Nsecs 00:00:00 UTC, Jan 1, 1970.  */
> 
> Would it make sense to add some paddigin then at least? In both
> cases? Or is it too late for this?

I can see why adding some padding would be useful if the structs were
not packed and we wanted to enforce 32/64 bit compatibility on x86.
However on ARM the field alignments on 32 and 64 bits are the same for
integer values so the padding wouldn't make a difference.
In any case both structs are packed, so the alignment is forced to be the
same by the compiler.
