Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2AOVAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:00:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46047 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053Ab2AOVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F133423.5070007@schaufler-ca.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
 <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
 <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
 <4F133423.5070007@schaufler-ca.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 15 Jan 2012 12:59:41 -0800
X-Google-Sender-Auth: d-AVClbh1tzyVAwq84FwnPpkDTE
Message-ID: <CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 12:16 PM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> On 1/14/2012 12:22 PM, Linus Torvalds wrote:
>>
>> And yes, I really seriously do believe that is both safer and simpler
>> than some model that says "you can drop stuff", and then you have to
>> start making up rules for what "dropping" means.
>>
>> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
>> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
>> that no, we should not even allow that. It's simply all too "subtle".
>
>
> I am casting my two cents worth behind Linus. Dropping
> privilege can be every bit as dangerous as granting privilege
> in the real world of atrocious user land code. Especially in
> the case of security policy enforcing user land code.

Can you think of *any* plausible attack that is possible with my patch
(i.e. no_new_privs allows setuid, setresuid, and capset) that would be
prevented or even mitigated if I blocked those syscalls?  I can't.
(The sendmail-style attack is impossible with no_new_privs.)

Also, how would you even block setuid(2) in a non-confusing manner?
The semantics and error returns are already such a disaster than it's
barely worth it for anything to check the return value.

>
> This even more important in environments that support fine
> granularity of privilege, including capabilities and SELinux.
> Under SELinux a domain transition can increase, decrease or
> completely change a process' access rights and there is really
> no way for the kernel to tell which it is because that's all
> encoded in the arbitrary SELinux policy. Smack does not try
> to maintain a notion of hierarchy of privilege, so the notion
> of any change being equivalent to any other is in line with
> the Smack philosophy.
>

My patch does not (barring bugs) allow selinux domain transitions.  I
certainly think that all security transitions that vary across
distributions should be blocked by no_new_privs.

--Andy
