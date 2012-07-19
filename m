Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2GSP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:26:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GSP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:26:21 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=NDtWZ_l1pBPoVTluc6UA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Thu, 19 Jul 2012 11:26:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120719152618.GD16873@home.goodmis.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 02:17:30PM -0700, Linus Torvalds wrote:
> 
> The *two* requirements (and they're really the same theme) I
> personally think we should have for this are
> 
>  -  I think every single "select" for these things should come with a
> comment about what it is about and why the distro needs it (to show
> there was some thought involved and not just a blind "took it from the
> distro config")

What about expanding on Alan's idea. I'm guessing that 99% of the users
build the kernel for the box that they are running. If this is the case,
perhaps we can get the distros to add a:

  /usr/share/Linux/Kconfig

And this Kconfig would have something like:

bool "Distro X config"
 select A
 select B
 select C
 [...]

Perhaps with a comment for each select. Or have the comments in the help
section.

Then have the kernel kbuild system check if this file exists and include
it.

Of course the kbuild system would need to verify that the selects exist,
and perhaps warn if they do not. But the nice thing about this is that
you would get the minconfig for the system you are running. When the
system is updated to a new version, the minconfig would be updated too.
The list of selects would not have to live in the kernel, nor would the
kernel need to maintain the list for N+1 different distributions.


> 
>  - It should be about *minimal* settings. I'd rather have too few
> things and the occasional complaint about "oh, it didn't work because
> it missed XYZ" than have it grow to contain all the options just
> because somebody decided to just add random things until things
> worked.

Side note, and this is for the 1%. If you want a true minconfig for your
system, ktest can do that for you. You can set it up to run a test to
create a minimum config that will boot (and optionally run some test you
specify). It turns off configs in order of importance (chooses those
that select a lot, or are depended on most, first), and sees if it can
boot without the config. The end result can be rather a very small set
of configs.

See tools/testing/ktest/examples/include/min-config.conf for more
details.

-- Steve

> 
> Other than that, even if it only gets you *closer* to a kernel that
> works with that distro, I think it doesn't have to be all that
> perfect. Because the alternative is what we have now.
> 
>            Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
