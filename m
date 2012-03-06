Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2CFSWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:22:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32932 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab2CFSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:22:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.133.216 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Tue, 6 Mar 2012 22:22:10 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
Message-ID: <20120306182210.GJ29367@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkiOY-p7duD_wfed_Tk8T8SR5r1JCTa=0ne3-VQ30mQE-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgNAkiOY-p7duD_wfed_Tk8T8SR5r1JCTa=0ne3-VQ30mQE-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:00:14AM +1300, Michael Kerrisk (man-pages) wrote:
> Hi Cyrill,
> 
> Just a couple of comments for the moment.
> 
> On Thu, Mar 1, 2012 at 1:23 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Tejun Heo <tj@kernel.org>
> > CC: Pavel Emelyanov <xemul@parallels.com>
> > ---
> >  man2/prctl.2 |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 104 insertions(+), 0 deletions(-)
> >
> > diff --git a/man2/prctl.2 b/man2/prctl.2
> > index effad2a..4d6244f 100644
> > --- a/man2/prctl.2
> > +++ b/man2/prctl.2
> > @@ -378,6 +378,110 @@ Return the current per-process machine check kill policy.
> >  All unused
> >  .BR prctl ()
> >  arguments must be zero.
> > +.TP
> > +.BR PR_SET_MM " (since Linux 3.3)"
> > +Allows a user to modify certain kernel memory map descriptor fields
> > +of the calling process.
> > +Usually these fields are set by the kernel and dynamic loader (see
> > +.BR ld.so (8)
> > +for more information) and a regular application should not use this feature.
> > +Still there are cases such as self-modifying programs, where a program might
> > +find it useful to change its own memory map.
> 
> By the way, do you have a *simple* program that demonstrates some
> usage of R_SET_MM?

Hi Michael,

well, at moment we've only crtools itself which uses this facility,
so if we need complete standalone example I need to think about it.

> 
> > +The kernel must be built with
> > +.BR CONFIG_CHECKPOINT_RESTORE
> > +option turned on, otherwise this feature will not be accessible
> > +from a user space level.
> > +The calling process must have
> > +.BR CAP_SYS_ADMIN
> > +(see
> > +.BR capabilities (7)
> > +for details) capability granted.
> 
> As we discussed earlier (offlist), there are probably better choices
> than the hugely overloaded CAP_SYS_ADMIN (see
> http://man7.org/linux/man-pages/man7/capabilities.7.html). And if the
> capability governing PR_SET_MM is to change, then it would be good to
> do so before 3.3 is released. What are the plans on this point?
> 

Yeah, I thought about changing it to CAP_SYS_RESOURCE here.
And I'll post a patch. The problem at moment that there another
two snippets needed for prctl -- ability to set new /proc/pid/exe
symlink and to obtaine clear-tid-address. So there is a discussion
now about symlink change. Once we finish with it -- i'll post
update for capability.

If you prefer to have it done earlier -- no problem, I'll cook
a patch today instead on top of everything we've already
merged into linux-next. What would you prefer?


	Cyrill
