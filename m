Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1BGQAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:00:55 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:25586 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1BGQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:00:54 -0500
X-IronPort-AV: E=Sophos;i="4.60,438,1291593600"; 
   d="scan'208";a="4196472"
Date: Mon, 7 Feb 2011 16:02:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D4CA568.70907@goop.org>
Message-ID: <alpine.DEB.2.00.1102071600090.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011, Jeremy Fitzhardinge wrote:
> >  		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
> >  		pmd = pmd_offset(pud, _brk_end - 1);
> > -		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
> > -			pmd_clear(pmd);
> > +		addr = (_brk_end + PMD_SIZE - 1) & PMD_MASK;
> 
> I guess its OK if this is >_end, because the pmd offset will be greater
> than _end's.  But is there an edge condition if the pmd_offset goes off
> the end of the pud, and pud page itself happens to be at the end of the
> address space and it wraps?
> 
> > +		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1)) {
> Could _end be in a different pud from _brk_end?  Could this walk off the
> pud page?
> 
> Or is it moot, and there's a guarantee that the whole space is mapped
> out of the same pud page?  I guess the original code has the same
> concern, so this patch leaves the status quo unchanged.
> 

Indeed. I had this doubt myself, but I thought there must have been a
smart reason why _brk_end and _end must be on the same pud, so I left it
unchanged.
