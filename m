Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2LHX6C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 18:58:02 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49897 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2LHX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 18:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com> <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 8 Dec 2012 15:57:39 -0800
Message-ID: <CALCETrXC9hnBtqHguHh_tXphNutarPYj-nnUA_VAtY9XsfSbpA@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 3:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Again (any mainly because I feel like there's a giant mental
> disconnect here in that I really don't understand wtf the current /
> POSIX system is trying to accomplish): what would be wrong with a
> model in which capabilities could be freely passed from parent to
> child?  Why would it be insecure?  Why would it be error-prone?
> There's got to be *some* reason why it's not in use right now.
>
> I can speculate as to the reason the current scheme is barely used
> except internally to a few daemons (and why AFAIK there is no one
> making serious use of fI): it's basically incomprehensible.  Security
> systems should be simple enough to understand and analyze.  "Here is
> the set of things that I and my descendants can do" (the Windows
> model) is simple.  "Here is the set of things I can do (pP).  Here is
> a different set of things that a certain class of my descendants can
> do (pI).  Here is the class of descendants that can do those things
> (fI).  And here's a different class of descendants that can do things
> no matter who invokes them (fP)." is really hard to understand.
>
> It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
> doesn't mean anything.  Is he authorized to back things up to
> encrypted storage?  Is he authorized to read any file for any purpose?
>  Is he authorized to read things on behalf of properly authenticated
> remote users?  No one knows because it depends entirely on what set of
> binaries with CAP_DAC_READ_SEARCH=i he can find.
>
> * I see "If pathconf() indicates that {_POSIX_CAP_PRESENT} is not in
> effect for a file, then the capability state of that file shall be
> implementation defined."  I think this means that the designers didn't
> actually decide whether fI should default to all zeros or all ones.

I just tried to search to find actual uses of pI/fI.  Here's what I found:

http://www.engardelinux.org/modules/index/list_archives.cgi?list=linux-security-module&page=0144.html&month=2010-04

A user (Stephen Hemminger, who presuambly understands Linux fairly
well...) who gave up because normal programs couldn't inherit
capabilities.

http://fpmurphy.blogspot.com/2009/05/linux-security-capabilities.html

Gives an (incorrect, AFAICT) example in which pI=cap_net_raw means "can ping"

http://forums.fedoraforum.org/showthread.php?t=203879

An unanswered question which the poster thought (I think) that giving
a user a capability would have some effect.

OK, bored of this search now.  Having trouble finding anything that works.

--Andy
