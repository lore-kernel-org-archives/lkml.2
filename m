Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2JXKAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:00:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54166 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab2JXKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:00:03 -0400
Date: Wed, 24 Oct 2012 13:59:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, xemul@parallels.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
Message-ID: <20121024095959.GA30240@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
 <20121024084515.GB30983@moon>
 <20121024204746.8a8c0fa14b6495b5d5013db4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024204746.8a8c0fa14b6495b5d5013db4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:47:46PM +1100, Stephen Rothwell wrote:
> Hi Cyrill,
> 
> On Wed, 24 Oct 2012 12:45:15 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> >
> >  static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >  {
> > +#define __VM_FLAG(_f, _s)	[ilog2(_f)] = {(const char [2]){_s}}
> 
> I really don't think you need the cast (and it may hide bad usages) or
> the second set of braces.  Thus:

Hi Stephen, could you please elaborate, which bad usage hiding could be there?

> Further is there any reason for the struct?
> 
> #define __VM_FLAG(_f, _s)	[ilog2(_f)] = _s
> 
> static const char mnemonics[BITS_PER_LONG][2] = {
> ...
> };

Well, good point, though the benefit of using stucture here
could be easier way for extension if needed. The compiled result
is the same as for plain array or structure, so I would rather
stick with struct here, until contrary proved (I mean it's not
a problem to update the patch and use array here but I still
think struct it better in long term). If you guys think that I
should move it to array -- no problem, i may update ;)

> >  	seq_puts(m, "VmFlags: ");
> >  	for (i = 0; i < BITS_PER_LONG; i++) {
> > -		if (vma->vm_flags & (1 << i))
> > +		if (vma->vm_flags & (1ul << i)) {
> >  			seq_printf(m, "%c%c ",
> >  				   mnemonics[i].l[0],
> >  				   mnemonics[i].l[1]);
> 
> 				   mnemonics[i][0], mnemonics[i][1]
> 
> /me looks for another bike shed :-)

Heh :)
