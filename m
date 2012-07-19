Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2GSQIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:08:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GSQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:08:09 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=lmvw-GIOEkBx2I_6zBoA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342714088.12353.33.camel@gandalf.stny.rr.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 12:08:08 -0400
In-Reply-To: <20120719154521.GC8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 11:45 -0400, Josh Boyer wrote:
> Of course the kbuild system would need to verify that the selects exist,
> > and perhaps warn if they do not. But the nice thing about this is that
> > you would get the minconfig for the system you are running. When the
> > system is updated to a new version, the minconfig would be updated too.
> > The list of selects would not have to live in the kernel, nor would the
> > kernel need to maintain the list for N+1 different distributions.
> 
> Is there a reason you don't want distro maintainers to maintain these
> files in the upstream git tree?  (You said "the kernel need to
> maintain", but I would expect the distro maintainers to be doing that
> work.)
> 
> I think it would actually be beneficial to maintain them upstream
> instead of in distro kernel packaging.  You'd be able to track the
> history of changes with git.  You would see for a given kernel
> version what options are set for each distro (e.g. F17 can support
> NEW_FOO_THING but F16 userspace can't so it doesn't select that).
> Perhaps most importantly, it provides a consolidated view of what
> options various distros are setting and allows the distro maintainers to
> easily do comparisons.

Then we'll have a list of options in each kernel:

 Fedora 16
 Fedora 17
 Fedora 18
 [...]
 Debian x
 Debian x+1
 Debian x+2
 [...]
 Ubuntu y
 Ubuntu y+1
 [...]

What about older kernels? Say you installed Fedora 18 with an older
kernel that doesn't know what to select? Having the distro tell the
kernel what it needs seems to me the easiest for the 99% case.

Also, if something isn't supported by the older kernel, it would warn
the user about it. That way the user can be told that their older kernel
won't work with this version of the distro. And there wont be as many
surprises. If the user is told "your init wont work with this kernel"
before they compile it, then they shouldn't complain if they decide to
install this older kernel and their box doesn't boot.

-- Steve


