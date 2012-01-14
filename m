Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2ANN4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 08:56:20 -0500
Received: from mail2.shareable.org ([80.68.89.115]:57585 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2ANN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 08:56:18 -0500
Date: Sat, 14 Jan 2012 13:55:49 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
Message-ID: <20120114135549.GZ7180@jl-vm1.vm.bytemark.co.uk>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com>
 <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
 <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:
> > So I bet the google chrome people are not at all interested in
> > "running random binaries", and might want execve() very much for
> > "running some specific binaries that we ship with or install from the
> > browser".
> 
> I want to be able to run "magic_seccomp_sandbox gv somefile.ps".  And
> I want that to still work even if my distro gets fancy and uses
> selinux policy to prevent gv from accessing the network (which would
> not be an unreasonable thing to do).  The chromium project already has
> a little seccomp wrapper that can (sort of) do this.

Chrome also comes with NaCL.  They *are* "running random binaries",
but they use code analysis to check the code first.  Maybe because
seccomp wasn't good enough ;-)

> > So I really think that the *only* valid model is the "fail the execve
> > on any changes", not the "mnt-nosuid" approach of trying to run things
> > with the wrong permissions and get perhaps odd results. And I think it
> > works even - and perhaps *especially* - in models like selinux or
> > apparmor that do have a lot of "implicit MAC knowledge" on specific
> > binaries.
> 
> Is the current exec_no_trans check enough for you?  With my patch,
> selinux can already block the execve if it wants.  (The policy is the
> same as it would be if a program explicitly asked to run the new
> executable with an unchanged security context.)  I'd be happy to fail
> the exec in AppArmor, and then maybe AppArmor will change its mind
> if/when users get annoyed :)

Does SELinux block if userspace does exec entirely in userspace using
mmap() and not execve()?  If not, why is execve() allowed to be different?

-- Jamie
