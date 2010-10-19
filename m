Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0JSVyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:54:40 -0400
Received: from claw.goop.org ([74.207.240.146]:55875 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab0JSVyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:54:40 -0400
Message-ID: <4CBE139E.3060004@goop.org>
Date: Tue, 19 Oct 2010 14:54:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v4 00/10] xen: initial domain support
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop> <20101019211448.GA10109@kroah.com>
In-Reply-To: <20101019211448.GA10109@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/19/2010 02:14 PM, Greg KH wrote:
> On Tue, Oct 19, 2010 at 12:16:31PM +0100, Stefano Stabellini wrote:
>> Hi all,
>> this series implements the basic support needed to boot Linux as initial
>> domain on Xen: the target is not to add full featured dom0 support in
>> the kernel but to be able to boot Linux on Xen on native.
> Nice, but what real use is this?
>
> I thought people wanted dom0 support, this doesn't seem to give them
> that.  Is that still the end-goal here, and this is merely a
> stepping-stone to get there?

Yes, it's a significant step there.  Once that's merged the main missing
piece is backend drivers, which we can probably get into a mergable form
for the next window.  And in the meantime, they're a fairly
self-contained thing to maintain out of tree (like other drivers).

Our strategy has been to put together a cluster of patch series which
each have their own intrinsic value, but are also all leading to full
dom0 support.  For example, Stefano's pv-hvm patches are useful for
running Linux as a fully virtualized domain under Xen, but the reworking
of the interrupt infrastructure in a way that dom0 support requires. 
Likewise, Konrad's work on pci-passthrough for domU domains adds all the
machinery required for a Xen domain to have direct access to hardware,
which is also what dom0 requires.

This particular series introduces the pieces needed for the kernel to
actually boot up to usermode as dom0, which has some value even if it
doesn't yet allow you to start new domains (well, you could, but they
wouldn't have any devices).

The net result is that there will be no massive "Xen dom0" patch series,
since that has been pretty clearly rejected in the past.  Instead full
dom0 support is being implemented - at least to some extent - as the
emergent result of a number of Xen-related patches.  These patches also
touch very little code outside of the existing Xen codebase, so there
shouldn't be much scope for controversy.

    J
