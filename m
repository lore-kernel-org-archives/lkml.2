Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LDNu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:50:26 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:37686 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab2LDNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:50:04 -0500
Date: Tue, 4 Dec 2012 13:54:45 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121204135445.GA7420@mail.hallyn.com>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
 <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
 <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com>
 <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> >> d) If I really wanted, I could emulate execve without actually doing
> >> execve, and capabilities would be inherited.
> >
> > If you could modify the executable properties of the binary that has
> > the privilege to wield a privilege then you are either exploiting an
> > app bug, or doing something the privileged binary has been trusted to
> > do.
> 
> That's not what I mean.  I would:
> 
> fork()
> munmap everything
> mmap ld.so
> set up a fake initial stack and the right fd or mapping or whatever
> just to ld-linux.so
> 
> That's almost execve, and privilege inheritance works.

But of course that is why you only want to fill fI on programs you trust
not to do that.  What you are arguing is that you want to give fI on
programs you don't trust anyway, and so heck why not just give it on
everything.

Anyway, implementing the features you want in a new module is encouraged,
so long as the behavior of existing module stays the same.

-serge
