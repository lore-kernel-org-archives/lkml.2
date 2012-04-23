Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2DWPiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:38:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48535 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2DWPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:38:01 -0400
Date: Mon, 23 Apr 2012 11:32:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423153222.GE24481@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 03:27:32PM +0000, Luck, Tony wrote:
> > Because, if you'd hooked into it, just imagine one fine day, when we
> > remove mcelog support, what screaming the xen people will be doing when
> > mcelog doesn't work anymore.
> 
> Agreed. Even before we get to deleting mcelog, "struct mce" can change (new
> fields could be added) ... and you don't want to have your hypervisor to
> have to know which version of Linux it is talking to.

I am having a hard time seeing how this is different from 'struct mce'
changing and the hardware remaining the same?

Can't the MCE check drivers deal with that - I mean that is their purpose -
to extract some "blob" of data from the hardware, massage it in the software
structure, and send its way. If you add some more fields in the software
structure - either the hardware can provide it or not. If not, it will have
to emulate it. This would be the same case with this driver.

This driver is _not_ doing a strict bit-by-bit copy of 'struct mcinfo'
to 'struct mce'. It is plucking the right bits and setting them in
'struct mce'.
