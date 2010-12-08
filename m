Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0LHL7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:59:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46569 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0LHL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:59:15 -0500
Date: Wed, 8 Dec 2010 12:58:06 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Greg KH <greg@kroah.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
Message-ID: <20101208115806.GA11716@aftab>
References: <20101111141358.GA4641@kroah.com>
 <1289488576-18117-2-git-send-email-joerg.roedel@amd.com>
 <20101207210512.GA14849@kroah.com>
 <4CFEF637.4020203@goop.org>
 <20101208041528.GA2211@kroah.com>
 <1291800855.13966.4404.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291800855.13966.4404.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 04:34:15AM -0500, Ian Campbell wrote:
> On Wed, 2010-12-08 at 04:15 +0000, Greg KH wrote:
> > On Tue, Dec 07, 2010 at 07:06:31PM -0800, Jeremy Fitzhardinge wrote:
> > > On 12/07/2010 01:05 PM, Greg KH wrote:
> > > > On Thu, Nov 11, 2010 at 04:16:14PM +0100, Joerg Roedel wrote:
> > > >> commit fd89a137924e0710078c3ae855e7cec1c43cb845 upstream
> > > > applied, thanks.
> > > 
> > > This will need as well 5b5c1af104ab5adec1be9dcb4c787492d83d8d83 to
> > > prevent Xen regressions.
> >
> > So should I add that to a specific release? The next .36 stable or something else?
> 
> 5b5c1af104ab5 fixed an issue exposed by b40827fa7268. I'm not sure if
> fd89a13792 also exposes a similar issue, but I think it does not:
> 
> It looks to me like fd89a13792 only reads from swapper_pg_dir and writes
> to trampoline_pg_dir which is unpinned (and unused) under Xen and hence
> there is no problem and 5b5c1af104ab5 is not needed.

I tend to agree with Ian's assessment here.

Let me put it this way: have you guys seen any Xen-related regressions
with fd89a13792? I mean, this patch went in after 2.6.36-rc1 and if
it were breaking Xen, we (or maybe you :)) would've caught it by now,
right?

> b40827fa7268 is in 2.6.37-rc and doesn't seem to be targeted for a
> stable backport AFAICT.

Nope, since it's not fixing a bug or fits any other of the stable rules.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
