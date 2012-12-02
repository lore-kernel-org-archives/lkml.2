Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2LBW04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 17:26:56 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40185 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LBW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 17:26:55 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
	<CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
	<CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com>
Date: Sun, 2 Dec 2012 14:26:54 -0800
X-Google-Sender-Auth: wGi0PcjzvlVi9pr2evPQwTbblKo
Message-ID: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 10:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, Dec 2, 2012 at 9:21 AM, Andrew G. Morgan <morgan@kernel.org> wrote:
>> There is a fairly well written paper ;-) explaining how things are
>> supposed to work:
>>
>>   http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf
>>
>> The inheritable set is not intended to work the way you seem to want.
>> Naive inheritance like that is quite explicitly the opposite of what
>> was designed.
>
> I'm aware that the system was designed, or perhaps evolved, to prevent
> users with uid != 0 from inheriting capabilities unless vfs
> inheritable caps are granted on a per-file basis.  I want a way around
> that -- I want to mix non-root, capabilities, and exec.  This is damn
> near impossible right now if I don't have CAP_SETFCAP or root's
> explicit, per-program cooperation.  CAP_SETFCAP is essentially
> equivalent to "let me do anything".
>
> As it stands, using something like pam_cap to grant a user cap_net_raw
> is useless -- that user can't use the privilege because (unless uid ==
> 0) the privilege will never end up in the permitted set.

Have you tried adding fI of cap_net_raw to the file to be executed?

Cheers

Andrew

>
> I want to come up with a way to change this that will, convincingly,
> not open up any new security holes.  The current concept of process
> inheritable capabilities seems so vague and so oddly defined that I'm
> not sure I want to touch it.  In an ideal world, I'd want pI <= pP and
> fP <= fI to be invariants, and I'd like programs without vfs caps set
> to have fI = <everything>.  Making this change will surely break
> something, though.
>
> I'm looking for ideas.
>
> --Andy
