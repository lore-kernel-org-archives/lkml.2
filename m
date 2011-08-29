Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1H2Wup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:50:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60260 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1H2Wun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:50:43 -0400
Subject: Re: linux-next: build failure in Linus' tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
In-Reply-To: <20110830083218.1819a5d73c3a33e5053e8312@canb.auug.org.au>
References: <20110829104451.1c777e24ff72823d1e399f12@canb.auug.org.au>
	 <20110830083218.1819a5d73c3a33e5053e8312@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:50:42 -0700
Message-ID: <1314658242.3078.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 08:32 +1000, Stephen Rothwell wrote:
> Hi Linus,
> 
> On Mon, 29 Aug 2011 10:44:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the fixes tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > arch/powerpc/kernel/built-in.o: In function `.sys_call_table':
> > (.text+0xbd00): undefined reference to `.sys_nfsservctl'
> > arch/powerpc/kernel/built-in.o: In function `.sys_call_table':
> > (.text+0xbd08): undefined reference to `.compat_sys_nfsservctl'
> > 
> > Caused by commit f5b940997397 ("All Arch: remove linkage for
> > sys_nfsservctl system call") which also missed parisc.
> > 
> > I will apply this patch for today:
> 
> Will you please appply this?  (repeated for ease of inclusion)
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 29 Aug 2011 10:38:57 +1000
> Subject: [PATCH] remove remaining references to nfsservctl
> 
> These were missed in commit f5b940997397 "All Arch: remove linkage
> for sys_nfsservctl system call" due to them having no sys_ prefix
> (presumably).
> 
> Cc: NeilBrown <neilb@suse.de>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-parisc@vger.kernel.org
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks for finding this ... definitely acked by me if necessary.

James


