Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2LJPAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:00:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2LJO77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:59:59 -0500
Date: Mon, 10 Dec 2012 08:59:50 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121210145950.GC8137@sergelap>
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap>
 <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com>
 <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
> doesn't mean anything.  Is he authorized to back things up to
> encrypted storage?

We're talking about privileges at the kernel level here, and there is
no way this could be expressed at that level.

Higher level tools could/should certainly be exposing things at this
level.

BUT

You *are* doing a good job of making me feel that we should have
per-user fI xattrs or acls.  Sudo is popular because people like to say
"user joe can run foo with privilege".  Most people will never want to
be bothered to say "user joe can run foo with CAP_XYZ" (versus "as
root"), but I do think we could get programs/packages to do that.

Note that another difficulty here likes in the age-old, as yet
unanswered imo, question of "how do I easily figure out what caps I need
to run my program."  A few years ago I pointed to this (perhaps in
mostly private emails, don't recall) as something to be solved, but
the solution escapes me.

-serge
