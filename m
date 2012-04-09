Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab2DIVvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:51:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38960 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2DIVvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <1580647.pAHyaBF6MS@sifl>
References: <1540670.AFBi1SpGoi@sifl>
	<CAGXu5jL5nAY4=5OKhA6VPdrzkUjVuBTcLQuMxUSEv_=N=ohbzQ@mail.gmail.com>
	<1580647.pAHyaBF6MS@sifl>
Date: Mon, 9 Apr 2012 16:51:30 -0500
Message-ID: <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
Subject: Re: ANN: libseccomp
From: Will Drewry <wad@chromium.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Kees Cook <keescook@chromium.org>,
        libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 4:32 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Monday, April 09, 2012 12:16:30 PM Kees Cook wrote:
>> On Mon, Apr 9, 2012 at 11:58 AM, Paul Moore <paul@paul-moore.com> wrote:
>> > With the seccomp patches finally stabilizing a bit, it seems like now is a
>> > good time to announce libseccomp: a library designed to make it easier to
>> > create complex, architecture independent seccomp filters.
>> >
>> >  * http://sourceforge.net/projects/libseccomp/
>> >  * git clone git://git.code.sf.net/p/libseccomp/libseccomp
>>
>> This looks really great; nice work!

Agreed -- this is great to see!

>> I see that the arch check happens during _gen_bpf_build_bpf(), which
>> is excellent. Do you have any thoughts about including a call to
>> prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) by default as well?
>
> That is a good question, and I guess it comes down to another question of if
> anyone would want to use seccomp without NO_NEW_PRIVS.  If the answer is no
> then I'm comfortable adding it into the seccomp_load() function; however, if
> the answer is yes we might want to do something different.
>
> I haven't given much thought to this yet, so if you or anyone else feels
> strongly about the issue - either pro or con - I'd appreciate hearing the
> argument.

I guess the question is if there is an expectation that this library
be used with something like lxc, where a whole, functional system with
suid/fcaps binaries is contained.  In that world, it may not be
desirable to set the nnp bit.   The same is true if, for some reason,
the init task was to set a system-wide filter.

Most likely, default use of nnp is probably "the right thing", but
it'd be nice to be able to annotate when you really want to allow
privileged contexts to set filters without nnp.

thanks!
will
