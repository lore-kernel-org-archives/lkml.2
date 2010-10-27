Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0J0Rvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:51:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14173 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0J0Rvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:51:39 -0400
X-IronPort-AV: E=Sophos;i="4.58,247,1286164800"; 
   d="scan'208";a="10837614"
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <4CC8649F.5060408@linux.intel.com>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <4CC8649F.5060408@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 27 Oct 2010 18:51:36 +0100
Message-ID: <1288201896.10179.87.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 18:42 +0100, H. Peter Anvin wrote:
> On 10/27/2010 10:31 AM, Jeremy Fitzhardinge wrote:
> >   On 10/27/2010 10:18 AM, H. Peter Anvin wrote:
> >> On 10/27/2010 9:50 AM, Jeremy Fitzhardinge wrote:
> >>>
> >>> This never used to be a problem.  Perhaps we can change how
> >>> clone_pgd_range is used at boot time to avoid it in the Xen case (since
> >>> we don't care about the secondary pagetable)?
> >>>
> >>
> >> Xen shouldn't have any users of this, since it's used for low-level
> >> operations like SMP bootstrap, suspend to RAM, reboot and low-level
> >> BIOS functionality.
> >>
> >
> > Right, but it is being called smack in the middle of setup_arch().  It
> > looks like they could be hidden away in
> > native_pagetable_setup_start/done though.
> >
> 
> This is what makes me absolutely hate paravirt with a passion... "let's 
> hid things away in <obscure place> and make it absolutely impossible to 
> either follow the code flow or figure out what the intended semantics 
> are supposed to be."  (Let not even get me started on how ill-defined 
> the semantics of some of the paravirt operations are.)  In this case, at 
> the most you need a single flag of state... or you could even just 
> ignore this low-level data structure that you will never use in the 
> first place.  Ian's message just mentioned "a failure" and never 
> described in any way what kind of "failure" it was.

That was vague of me, sorry about that. The failure was Xen shooting the
guest due to an attempt to write to swapper_pg_dir directly, which isn't
allowed for active pagetables under Xen.

Ian.


