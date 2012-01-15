Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2AOUQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:16:44 -0500
Received: from nm21-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.220]:35802 "HELO
	nm21-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752055Ab2AOUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:16:42 -0500
X-Yahoo-Newman-Id: 96736.78593.bm@omp1031.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mfgh7usVM1lSfMeI27U9xlJr_Y6x.CBaBZp7v4_xx9OBtgB
 vgh4TRvpM0lRjS.LS1atuJF1.35e_kEFvCr.y8any8rq5QqcIe2WrgKj3X5j
 mjQuiLiumEAdYMnJGDjqZ1dgn37HQ.ty5.y6iNNv9RXO5UDvhENSKqPFII.H
 94y_aZVVhFOLqk65CzuFILd0AganAJ_YGMkq.BWQXeE9fWGDS_oxs4C4HnN1
 AeBPYTOGVN7p0lc.zehZ3ohE4vH5m55aug3L7CuX.ldbdlUuf6vveH9SGHi.
 yNV3FqxiiQMYYAMevK6nFuiUp4ygzRn20sUng5s3MHR_Olvt.0GX15_NzjJJ
 xWkumdxZNEDmIr1ys4Jr4Es1cxKUBpcdK_pbkaPSugJuAGxzCqqlJrQKZsaO
 VjxkXBWAm8fH14ci1TDKoXq68phUVIEPU9fJ4ohfe_scRZ.P6RjTEjlA-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F133423.5070007@schaufler-ca.com>
Date: Sun, 15 Jan 2012 12:16:35 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
References: <1326411506-16894-1-git-send-email-wad@chromium.org> <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com> <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com> <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com> <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com> <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com> <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
In-Reply-To: <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2012 12:22 PM, Linus Torvalds wrote:
> On Sat, Jan 14, 2012 at 5:30 AM, Jamie Lokier<jamie@shareable.org>  wrote:
>> Anyway the principle is there - CAP_NET_BIND doesn't necessarily mean
>> the daemon code is trusted.
> I really think all these arguments are *COMPLETELY* missing the point.
>
> You don't have to use the new flag if you don't want to. Just let it go.
>
> The point of the flag is to not allow security changes. It's that
> easy. If you want something else, don't use it.
>
> Because even "dropping capabilities" is quite often the wrong thing to
> do. To one person it's "dropping capabilities", to another it is "no
> longer running with the capabilities I need".
>
> We've had security bugs that were *due* to dropped capabilities -
> people dropped one capability but not another, and fooled code into
> doing things they weren't expecting it to do. So quite frankly, I
> believe that from a security standpoint it's a hell of a lot safer to
> just keep the rules really simple.
>
> Think of the "restrict" bit as "my universe will now run with this
> *known* set of permissions".
>
> And if you don't like it, don't use it. It really is that simple. But
> don't make the model more complicated. Don't confuse it with "but but
> capabilites" crap. The point of the patch is that it makes all of that
> go away. There are no capabilities. There only is what you can do.
>
> And yes, I really seriously do believe that is both safer and simpler
> than some model that says "you can drop stuff", and then you have to
> start making up rules for what "dropping" means.
>
> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
> that no, we should not even allow that. It's simply all too "subtle".

I am casting my two cents worth behind Linus. Dropping
privilege can be every bit as dangerous as granting privilege
in the real world of atrocious user land code. Especially in
the case of security policy enforcing user land code.

This even more important in environments that support fine
granularity of privilege, including capabilities and SELinux.
Under SELinux a domain transition can increase, decrease or
completely change a process' access rights and there is really
no way for the kernel to tell which it is because that's all
encoded in the arbitrary SELinux policy. Smack does not try
to maintain a notion of hierarchy of privilege, so the notion
of any change being equivalent to any other is in line with
the Smack philosophy.

>
> (I don't think Andrew's patch actually touched any of those paths, but
> I didn't check)
>
>                        Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

