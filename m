Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1BGS4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:56:13 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:59609 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:56:12 -0500
X-IronPort-AV: E=Sophos;i="4.60,438,1291593600"; 
   d="scan'208";a="4200432"
Date: Mon, 7 Feb 2011 18:58:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D50343E.1020906@kernel.org>
Message-ID: <alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org>
 <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Yinghai Lu wrote:
> On 02/07/2011 08:50 AM, Stefano Stabellini wrote:
> > On Sun, 6 Feb 2011, Yinghai Lu wrote:
> >> On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
> >>> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
> >>>> why not just move calling cleanup_highmap down?
> >>>>
> >>>> something like attached patch.
> >>>
> >>> This patch looks very clean and looks on the surface of it like it is
> >>> removing some ugly ad hoc code, but (as always) it needs a description
> >>> about the problem it solves and why it is correct.
> >>
> >> Sure.
> >>
> >>
> >> Jeremy and xen guys, can you please check if it works well with xen ?
> >>
> > 
> > Actually this patch makes things worse on xen, because before
> > cleanup_highmap() wasn't called at all on xen (on purpose) and now it
> > is, fully destroying all the mappings we have at _end.
> > 
> > Can we add a check on memblock reserved regions in cleanup_highmap()?
> > Otherwise could we avoid calling cleanup_highmap() at all on xen?
> 
> why DO xen need over-mapped kernel initial mapping?
> 
> what is in that range after _end to 512M?

The mfn list that is the list of machine frame numbers assigned to this
domain; it is used across the kernel to convert pfns into mfns.
It passed to us at that address by the domain builder.

