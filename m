Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1JYReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1JYReD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:34:03 -0400
Message-ID: <1319564009.3280.22.camel@localhost>
Subject: Re: [PATCH 05/10] user namespace: clamp down users of cap_raised
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de
Date: Tue, 25 Oct 2011 13:33:29 -0400
In-Reply-To: <20111025030314.GA27425@sergelap>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
	 <1318974898-21431-1-git-send-email-serge@hallyn.com>
	 <1318974898-21431-6-git-send-email-serge@hallyn.com>
	 <14652.1319014868@redhat.com> <20111024144334.GA26603@hallyn.com>
	 <CALQRfL4zCbzr_Fa0ySi96j06nw7ifocCxUjYUs6vXxeNvjCutQ@mail.gmail.com>
	 <20111024172842.GA13556@sergelap>
	 <CALQRfL7ZNv9+7tooJC8x8Pmz62QtnJ+-pVFRy_YspCG1BhZKzg@mail.gmail.com>
	 <20111025030314.GA27425@sergelap>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 22:03 -0500, Serge E. Hallyn wrote:
> Quoting Andrew G. Morgan (morgan@kernel.org):
> > On Mon, Oct 24, 2011 at 10:28 AM, Serge E. Hallyn
> > <serge.hallyn@canonical.com> wrote:
> > > Quoting Andrew G. Morgan (morgan@kernel.org):
> > >> Serge,
> > >>
> > >> It seems as if this whole thing is really idiomatic. How about?
> > >>
> > >> #define IN_ROOT_USER_NS_CAPABLE(cap)  \
> > >>    ((current_user_ns() == &init_user_ns) && cap_raised(current_cap(), cap))
> > >
> > > My objection to this was that it seems to encourage others to use it :)  I'm
> > > not sure we want that.  Also, IN_ROOT_USER_NS seems more generally useful.
> > 
> > What is driving the choice of when its appropriate? How can a
> 
> I'd like to say it's never appropriate.  The reason is that it bypasses
> the whole security_ops->capable() sequence, so for instance SELinux is
> kept in the dark.
> 
> > developer determine this? If you make it hard, presumably folk won't
> > do it by default, but will that create a burdon on others to go round
> > patching things like this up?
> > 
> > > But if I'm the only one who feels this way I'll go ahead and do it...
> > 
> > I'm more of a optimize for a human to read the source code (ie. debug
> > a problem) kind of person. If IN_ROOT_USER_NS is useful, you could
> > always define IN_ROOT_USER_NS_CAPABLE in terms of IN_ROOT_USER_NS &&
> 
> My other objection is that, in contrast to IN_ROOT_USER_NS(), which is
> very clear, IN_ROOT_USER_NS_CAPABLE() is not as helpful.  I'm sure a
> better name is out there somewhere, though.
> 
> > ... and provide both.
> > 
> > I guess I'm unclear, however, when you want developers to use one or
> > the other variant of the basic capable() functionality. Since I'm not
> > clear, I'm suspecting this is a fragile situation.
> 
> I think only security code (LSMs) should be using cap_raised directly.
> Everything else should go through the capable()/has_capability() family
> of functions.  Which, incidentally, have been (or are about to be) made
> less of a mess and thus less fragile by Eric Paris' patchset starting at
> http://www.spinics.net/linux/fedora/linux-security-module/msg11896.html

(sorry out all last week)

I was going to ask why we have these user at all.  Is there a reason
they are bypassing the LSM and not setting PF_PRIV?  Is the best
solution to just bring them back into the capable fold?

-Eric

