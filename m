Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2GSRdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:33:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2GSRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:33:45 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Fhk7czc5GNVHS_vXrysA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342719222.12353.58.camel@gandalf.stny.rr.com>
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
Date: Thu, 19 Jul 2012 13:33:42 -0400
In-Reply-To: <20120719171918.GD8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
	 <1342714088.12353.33.camel@gandalf.stny.rr.com>
	 <20120719171918.GD8469@zod.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:

> > What about older kernels? Say you installed Fedora 18 with an older
> > kernel that doesn't know what to select? Having the distro tell the
> > kernel what it needs seems to me the easiest for the 99% case.
> 
> How is the above not telling the kernel what it needs?  I'm confused how
> the location of such a file makes it's functionality and usefulness
> differ...  Quite possible I missed what you meant originally, but it
> sounds like we're talking about the same thing?

The point is, the user wont have to think "What distro am I running? and
what version am I running?". I don't even know what version of the disto
I'm currently running (Debian testing).

The point is, the current running distro supplies what is needed from
the kernel in order to work properly. The user does not need to 'select'
it. They would only have to select a 'add my distro min configs'.

A developer working with a user could just say, "select disto config"
without needing to know what distro the user has.

What happens if someone does a yum update, and the kernel requirement
changes slightly. The yum update should update
this /usr/share/Linux/Kconfig. But it's still set at Fedora X. The
kernel can not be updated for these slight changes.

> 
> Also, I'm not very convinced the 99% are going to be wanting to install
> shiny new versions of a distro with a kernel older than what the distro
> ships with.  I could be very wrong, but it seems like in-general the
> whole premise of this RFC was geared towards using new kernels on
> distros.

There are times when the update breaks something. A user may backport to
an older kernel where their Gizmo worked. I've done this to get webcams
working. I know I'm not the 99%, but the rational for my operation was a
99% thing to do: Crap, I upgraded my kernel and now my webcam doesn't
work. Oh well, download an older version and boot that one.

> 
> > Also, if something isn't supported by the older kernel, it would warn
> > the user about it. That way the user can be told that their older kernel
> > won't work with this version of the distro. And there wont be as many
> > surprises. If the user is told "your init wont work with this kernel"
> > before they compile it, then they shouldn't complain if they decide to
> > install this older kernel and their box doesn't boot.
> 
> kconfig already spits out warnings for symbols being selected that
> don't exist.

We can make these even bigger :-)   Add lots of stars (*) around them!

-- Steve


