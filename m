Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0LIDuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:50:32 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753372Ab0LIDua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:50:30 -0500
Date: Wed, 8 Dec 2010 21:50:25 -0600
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lenb@kernel.org, hmh@hmh.eng.br, mingo@elte.hu, tglx@linutronix.de,
        tony.luck@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gbeshers@sgi.com
Subject: Re: [RFC  - V2] - Mapping ACPI tables as CACHED
Message-ID: <20101209035025.GB6697@sgi.com>
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net> <4C743C0F.2010101@zytor.com> <20100826171704.GA21584@sgi.com> <4C76AD82.2030105@zytor.com> <20101208212244.GA24280@sgi.com> <4D00308B.2040009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D00308B.2040009@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 05:27:39PM -0800, H. Peter Anvin wrote:
> On 12/08/2010 01:22 PM, Jack Steiner wrote:
> > 
> > This patch substantially reduces the time to run ACPIDUMP on a large system:
> >  	527 seconds without the patch
> >  	  8 seconds with the patch
> > 
> 
> This is probably the worst possible motivation you can give here.
> Bootup time is much more of an issue.
> 
> However, this really needs Len's ack.

Sorry - should have included more info from the original posting.
The boot time speedup is the most critical. From the original mail:

	...
	The following experimental patch changes the kernel mapping for ACPI tables
	to CACHED. This eliminates the page attibute conflict & allows users to map
	the tables CACHEABLE. This significantly speeds up boot:

	        38 minutes without the patch
		27 minutes with the patch
		        ~30% improvement
	...

(Since the original posting, we've made additional reductions in
boot times. The absolute improvement from this patch is still the same
but the percentage improvement is now larger).


This is on a large SGI system. Boot time is reduced on smaller systems
but obviously the improvement is much less.

See the original mail for more details.

Len - the original patch had the cached/uncached mapping controlled by a
platform attribute (I'm paranoid). However, the community concensus was
that cached mappings were safe for all platforms.





--- jack
