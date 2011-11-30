Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1K3VG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:06:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59527 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1K3VG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:06:28 -0500
Date: Thu, 1 Dec 2011 01:06:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111130210622.GM14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <20111129203714.GH1775@moon>
 <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
 <20111130173739.GI14515@moon>
 <CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
 <20111130182310.GL14515@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111130182310.GL14515@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:23:10PM +0400, Cyrill Gorcunov wrote:
...
> 
> > > +       switch (opt) {
> > > +       case PR_SET_MM_START_CODE:
> > > +       case PR_SET_MM_END_CODE:
> > > +
> > > +               vm_req_flags = VM_READ | VM_EXEC;
> > > +               vm_bad_flags = VM_WRITE | VM_MAYSHARE;
> > > +
> > > +               if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
> > > +                   (vma->vm_flags & vm_bad_flags))
> > > +                       goto out;
> > 
> > Another random thought: given this very regular set of checks you're
> > doing, perhaps the flags should be part of a data structure instead,
> > just to reduce the size of this routine?
> > 
> > struct mm_flags {
> >   int req_flags;
> >   int bad_flags;
> > };
> > 
> > struct mm_flags opt_flags[] = {
> > ...
> >  { VM_READ | VM_EXEC, VM_WRITE | VM_MAYSHARE }, /* PR_SET_MM_START_CODE */
> >  { VM_READ | VM_EXEC, VM_WRITE | VM_MAYSHARE }, /* PR_SET_MM_END_CODE */
> > ...
> > 
> > then do validation before the switch statement all in one place, and
> > leave the switch for more programmatic checks?
> > 
> > -Kees
> > 
> 
> Nod! I'll update, thanks!
> 

You know Kees, I tried it, and finally I think it's overheaded, so I prefer
to stick with original version (no need to duplicate same data in two differen
memory places as it'll be in case of arrays, and since the VM_ flags are
constant the former code bloats kernel lesser. Thanks anyway!

	Cyrill
