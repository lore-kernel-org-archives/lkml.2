Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2GSWt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:49:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7744 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2GSWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:49:57 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=YuVrg9c0s9-Kg-Cz8WgA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342738194.12353.80.camel@gandalf.stny.rr.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 18:49:54 -0400
In-Reply-To: <20120719223519.GI8469@zod.bos.redhat.com>
References: <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
	 <1342714088.12353.33.camel@gandalf.stny.rr.com>
	 <20120719171918.GD8469@zod.bos.redhat.com>
	 <1342719222.12353.58.camel@gandalf.stny.rr.com>
	 <20120719175649.GF8469@zod.bos.redhat.com>
	 <1342721620.12353.75.camel@gandalf.stny.rr.com>
	 <20120719183645.GH8469@zod.bos.redhat.com>
	 <alpine.DEB.2.02.1207191357360.20176@asgard.lang.hm>
	 <20120719223519.GI8469@zod.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 18:35 -0400, Josh Boyer wrote:

> > >2... yeah.  I don't really know if that is going to pan out, but I am
> > >ever hopeful.  I'd be mostly concerned with people that are coding
> > >userspace applications using every whiz-bang kernel feature.  Or not
> > >paying attention at all to the kernel after the initial file creation
> > >and the options going stale (don't follow renames, etc).
> > 
> > it would be determined by the distro maintainers who maintain the
> > kernel config for that distro.
> 
> Erm... not in Steven's scheme.  At least I don't think distro kernel
> maintainers are going to willingly crawl through every application
> package that might depend on a kernel feature being enabled and maintain
> those files across X number of packages.

Correct. If we keep the selects in the kernel proper, then it would be
the kernel maintainer to make sure it works for the necessary
applications.

If we have a directory called /usr/share/Linux/Kconfig.d/ then the
individual packages could add their needed selects. Now this wouldn't be
for the average package. We don't need emacs developers adding any
configs here. It's just for those packages that are already tightly
coupled with the kernel (systemd, iptables, SELinux tools, etc).

-- Steve


