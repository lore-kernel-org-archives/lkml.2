Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1HBBSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:18:10 -0400
Received: from c60.cesmail.net ([216.154.195.49]:60120 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1HBBR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:17:59 -0400
Message-ID: <20110801211835.3tq9q5o50kwkk0c0-cebfxv@webmail.spamcop.net>
Date: Mon, 01 Aug 2011 21:18:35 -0400
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>, Nicolas Palix <Nicolas.Palix@inria.fr>,
        linux-kernel@vger.kernel.org
Subject: Re: Compat-wireless release for 2011-08-01 is (NOT) baked
References: <20110801190401.100CA40ED1@repository3.orbit-lab.org>
	<4E370ECF.80509@gnu.org>
	<CAB=NE6WyTKPx+0yt5P1ponajKUd70eqFJQLwH8s1_2hfPkoBTA@mail.gmail.com>
In-Reply-To: <CAB=NE6WyTKPx+0yt5P1ponajKUd70eqFJQLwH8s1_2hfPkoBTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> Question then is -- are we willing to require spatch for building the
> tarballs? I'm OK with this, anyone else?

Good question!  I think it may be worth it, but let's consider the arguments.

Against:

coccinelle is not nearly as widespread as other required tools (gcc,  
make, patch).

coccinelle depends on ocaml.  That's a whole programming language that  
many systems (including my home system with Fedora 15) don't have  
installed by default, even if the "development" was selected at the  
system install.

I don't know the status of coccinelle and ocaml packaging on various  
distros.  Asking users to compile both to have the latest wireless  
drivers is pretty cruel.

Even Fedora 15, as I found out while writing this message, mispackages  
coccinelle.  The dependency on ocaml-findlib is missing, so coccinelle  
is not functional when installed by yum.  I'm going to report is as  
soon as possible.

There are two names, spatch and coccinelle.  That's going to be  
confusing for the users.  They won't know which package to look for.   
Some will look for both.

For:

There is no need to have any special variant of coccinelle to  
cross-compile compat-wireless.

Popularization of coccinelle and ocaml may be a good thing.  More  
users means more eyeballs looking for bugs.

Patches will become more clear, at least for those knowing the basics  
of coccinelle syntax.  Non-trivial changes won't be buried in trivial  
ones.

compat-wireless will be more robust.

It may be possible to port compat-wireless to more kernels.  Or maybe  
more subsystems will be backported.  Replacing even large amounts of  
code would become easier.

While some people can be inconvenienced by the need to install  
coccinelle, it's a solvable problem for most users.  On the other  
hand, backporting compat-wireless to older kernels or backporting more  
features is something that very few people can do, and those people  
should not be bothered with trivial stuff too much.

My experience shows that placing too much boring stuff on the  
shoulders of the developers is detrimental to the users in the long  
run.  It's one thing to require extensive testing, which can be  
automated, or to require compatibility with older tools, which can be  
easily achieved.  On the other hand, requiring to update huge patches  
manually is boring and error prone.  Make the developers busy with  
boring stuff, and they will stop making improvements that nobody else  
can do.

-- 
Regards,
Pavel Roskin
