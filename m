Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0JOTRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:17:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:31183 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0JOTRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,337,1283756400"; 
   d="scan'208";a="617155961"
Subject: Re: compat-wireless question
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=6aVHyr98avc07UtWgDkV=SdmKW2HXNfSRY3KU@mail.gmail.com>
References: <E9954878DD1FB34FAE5187FB88C58A35012EE46BC3@orsmsx506.amr.corp.intel.com>
	 <AANLkTi=6aVHyr98avc07UtWgDkV=SdmKW2HXNfSRY3KU@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 12:16:48 -0700
Message-Id: <1287170208.13051.34.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Fri, 2010-10-15 at 12:05 -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 15, 2010 at 10:40 AM, Guy, Wey-Yi W <wey-yi.w.guy@intel.com> wrote:
> > Hi Luis,
> >
> > Simple compat-wireless question
> >
> > There are two type of compat-wireless
> > 1.       Bleeding-edge compat-wireless
> > 2.       Stable compat-wireless
> >
> > If I understand correctly, bleeding-edge compat-wireless took the latest
> > from wireless-next-2.6,
> 
> Bleeding edge comes from linux-next.git instead of wireless-next.git
> as we also get Ethernet driver updates that way. Ethernet drivers are
> easy to port into compat-wireless so I have already added all Atheros
> Ethernet drivers into it, feel free to send patches to Intel Ethernet
> :)
> 
> > is it also include wireless-2.6 which is bug fix.
> 
> No, it just uses linux-next.git, but yeah linux-next.git would rebase
> on top of Linus' tree anyway so it would eventually get all of the
> respective stable fixes. Stephen would then just drag in all trees
> sequentially.
> 
> > How about stable compat-wireless, it is base on stable tree, so I believe it
> > has all the bug fix for the stable kernel, am I correct?
> 
> I based the stable release off of H. Peter Anvin's linux-2.6-allstable.git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
> 
> After Linus releases a kernel, say 2.6.36, then new extra version
> fixes, say 2.6.36.1, 2.6.36.2, etc, will not be available on Linus'
> tree, but you can instead get them from the linux-2.6-allstable.git
> tree. What is neat about that tree too is it also has the older stable
> extra version updates. So whenever a stable kernel extra version gets
> released we can make a new compat-wireless-2.6.3x.y. You can find them
> here:
> 
> http://wireless.kernel.org/en/users/Download/stable/
> 
> Now as of the compat-wireless-2.6.36 releases I started noticing we
> can do something better as we approach the merge window. The issue
> with the merge window is that there are some patches which are marked
> as stable on the commit log entry (Cc: stable@kernel.org) but not all
> of these will make it to Linus' next rc release as the focus for the
> RC is to fix regressions only. Right or wrong, some stable patches
> eventually make it into the first extra version release of the kernel
> but not on the stable release of the kernel. Some of these stable
> fixes are still important though so to help with testing and getting
> users/customers these fixes I've started sucking all pending stable
> fixes from linux-next.git on the compat-wireless-2.6.36 releases. I
> annotate this is done on a release by postfixing an "s" to the
> release. You can also find all the stable patches which were sucked
> out of linux-next.git by looking at the pending-stable/ directory. I
> regenerate these every new RC release of the kernel or extra version
> bump, but started this only as of the linux-2.6.36.y branch of
> compat-wireless.
> 
> Furthermore, I realize that at times a vendor may have a patch that
> although it did not make it into the stable release of the kernel it
> may be important for the vendor for some customers, so because of this
> we have the linux-next-cherry-picks/ directory. This directory is for
> patches which have already been merged into linux-next.git but will
> not make it into the stable kernel release. I took this further two
> more steps too, just because sometimes a maintainer may be on
> vacation, have died, or whatever, so your patches may not get merged
> yet. In these cases you can submit patches for inclusion into the
> linux-next-pending/ directory of compat-wireless. This is for patches
> which have *at least* been posted to a public mailing list but for
> whatever reason haven't yet been merged. Then lastly we have the crap/
> directory of compat-wireless. This for patches which have not even yet
> been posted to a mailing list for whatever reason. An example may be
> that there is a known issue but yet the patches are important enough.
> 
> The purpose of all these directories is to let you customize stable
> compat-wireless releases, suited for whatever purpose you have. I've
> started sucking in all linux-next.git stable fixes not yet merged for
> now, and am will soon start incorporating a linux-next-pending/ patch
> to account for the lag in getting a patch reviewed.
> 
> Feel free to use these as well, I welcome patches to help your needs.
> 
> Please let me know if you have any other questions.
> 
>  
Thank you very much for the clear explanation, this is exactly what I
looking for.

the linux-next-cherry-pick/ directory especially interesting to me since
we need to deliver the latest new features to our customer. I will give
a try and might have more questions.

Wey


 

