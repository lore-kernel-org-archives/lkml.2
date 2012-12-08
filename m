Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2LHJvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 04:51:45 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:49343 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2LHJvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 04:51:41 -0500
Date: Sat, 08 Dec 2012 03:51:37 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Document how capability bits work
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        mtk.manpages@gmail.com
In-Reply-To: <CALCETrXOk74kcfqHBwuAZEY3rpZJFc65e0zZszu-34Qk+ui1dA@mail.gmail.com>
	(from luto@amacapital.net on Fri Dec  7 19:27:25 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1354960297.7646.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 07:27:25 PM, Andy Lutomirski wrote:
> On Fri, Dec 7, 2012 at 5:10 PM, Rob Landley <rob@landley.net> wrote:
> > On 12/07/2012 01:32:18 PM, Andy Lutomirski wrote:
> >>
> >> On Fri, Dec 7, 2012 at 11:21 AM, Serge Hallyn
> >> <serge.hallyn@canonical.com> wrote:
> >> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> >> ---
> >> >>  Documentation/security/capabilities.txt | 161
> >> >> ++++++++++++++++++++++++++++++++
> >> >>  1 file changed, 161 insertions(+)
> >> >>  create mode 100644 Documentation/security/capabilities.txt
> >> >
> >> > TBH, I think a pointer to the capabilities.7 man page would be  
> better.
> >> > (plus, if you feel they are needed, updates to the man page)
> >>
> >> Updating capabilities.7 wouldn't be a bad idea, but IMO it  
> certainly
> >> needs work.  For example, it says:
> >
> > ...
> >
> >> I would be happy to revise this patch to reference capabilities.7.
> >
> >
> > The capabilities.7 man page is existing maintained documentation on  
> how to
> > use this from userspace, which seems to be the point of your  
> document.
> > Having include/linux/uapi/capability.h mention its existence might  
> be good.
> > Feeding fixes to the documentation we've already got would be good.
> >
> > I read your document having largely ignored capabilities for years,  
> and
> > don't feel I have a better understanding of them after reading it.  
> (I'm
> > aware they exist, I'm aware they're used as a justification for  
> extended
> > attributes, I'm aware people think breaking a fireplace into a  
> bunch of
> > candleflames increases fire safety. I'm aware of
> > http://forums.grsecurity.net/viewtopic.php?f=7&t=2522 and I _used_  
> to be
> > aware of
> >  
> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html  
> but
> > kernel.org never bothered putting most of itself back together  
> after the
> > breakin last year and archive.org doesn't have a copy. I'm aware  
> that a
> > decade ago at Atlanta Linux Showcase in california Ted Tso was sad  
> nobody
> > was using them yet. But I haven't hugely been tracking changes over  
> the last
> > 5 years in how they work. It looks like figuring out who has what  
> involves
> > working through exercises in set theory that cannot be explained  
> using a 127
> > bit ascii set. Personally, I prefer "more dangerous" security  
> setups that
> > don't require I pull out scratch paper to reason about the state of  
> the
> > system, so perhaps I'm biased here.)
> 
> Heh.  I agree this stuff is shockingly complicated.  (And this
> document isn't wriiten in ASCII...)

The fact that you need multiple sets of capabilities per process  
(permitted, inheritable, effective), plus MORE sets (plural) of  
capabilities attached to executable files, plus the "capability  
bounding set" which is presumably so selinux can mess with it, plus a  
reset to all ones when you run an suid root program... And this is on  
_top_ of the existing uid/gid ownership stuff attached to every process  
and filesystem. And it's orthogonal to the namespace and cgroups stuff  
added to implement containers. AND the people who use capabilities  
still want to spray down the system with SELinux rulesets (or apparmor)  
on top of that...

The complexity of this mechanism does not fill me with confidence in  
its robustness, nor increase my desire to make extensive use of it. But  
then I don't normally do enterprise system administration, so I'm not  
the target audience.

> I actually wrote this file because I was reading the code and trying
> to figure out wtf was going on.  This is the result :)  I'll see if I
> can improve capabilities.7.
> 
> Any pointers to things you wanted to understand?

The only thing I really _want_ to understand about capabilities is why  
the lxc guys seem to think they need them to implement containers. (I  
think I have it written down somewhere, but don't remember off the top  
of my head.)

As to "how capatilities get set", the "transformation of capabilities  
during execve" bit of the man page seemed to cover it. (I got to the  
point where it said the capability bounding set is now a per-thread  
attribute, could NOT wrap my head around why anybody would even try to  
"secure" threads of the same process from each other, and wandered off.)

But the point is the current man page does a good job of documenting  
this stuff, which is a separate issue from whether or not I think the  
mechanism is a good idea. You seem to be suggesting that there are  
flaws in the man page, in which case I suggest fixing the man page.

Rob