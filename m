Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0KDDlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:41:21 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:59885 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0KDDlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:41:19 -0400
Date: Wed, 3 Nov 2010 23:40:56 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 04/30] staging/vme: allow non-dynamic allocation of bus
 numbers
Message-ID: <20101104034056.GC9037@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-5-git-send-email-cota@braap.org>
 <4CC7F3BE.5090503@ge.com>
 <20101027151327.GR10869@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027151327.GR10869@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 11:13:27 -0400, Emilio G. Cota wrote:
> On Wed, Oct 27, 2010 at 10:41:18 +0100, Martyn Welch wrote:
> > On 26/10/10 02:10, Emilio G. Cota wrote:
> > > From: Emilio G. Cota <cota@braap.org>
> > > 
> > > In a configuration with several bridges, each bridge is
> > > assigned a certain bus number depending on the order in which
> > > vme_register_bridge is called. This can complicate multi-bridge
> > > installations because the eventual bus numbers will depend
> > > on the order the bridges were loaded.
> > > 
> > > The appended allows bridges to register with a bus number of
> > > their choice, while keeping the previous 'first come, first
> > > served' behaviour as the default.
> > > 
> > 
> > I can't see where this is being used.
> 
> Each driver's .probe is fed with bus_number and slot_number.
> Normally the driver will check that pair against what it received
> through modparams and act accordingly.
> 
> For this to be reliable bus numbering should be consistent on
> a given system, i.e. it should be possible to always allocate
> the same bus number to a given bus. Otherwise, depending on
> which bridge is installed first, we'd get different bus numbers
> assigned.
> 
> Does that make it clearer now?
> 
> > I assume this is a part of future changes you wish to make?
> 
> AFAICT it affects the current model.

Martyn,

Have you had time to re-check this one?

Thanks

		Emilio

