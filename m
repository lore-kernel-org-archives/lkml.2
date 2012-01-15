Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2AOVc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:32:28 -0500
Received: from nm13.access.bullet.mail.mud.yahoo.com ([66.94.237.214]:28773
	"HELO nm13.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752461Ab2AOVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:32:25 -0500
X-Yahoo-Newman-Id: 989929.22595.bm@smtp108.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nrF27bQVM1kNLnChb_zy0FNW7xx6wPYNVcLXZrzJ_1XhBq_
 aknOBO1.YE9eto9WgjGGDgVcBDzj.QzAlfklEICC72bcabl9ftPgdHTUbjdg
 ebTRe_gkQj1l59hJbMeqlaIN92ZKiy_503POHHlVXlqqF23uzPH76SkTDA.I
 690haAJhZas4DXgIuOp.oHmhhjD.9yzT2SkdCjRUIvVeuD3KFA.MCRfseYBf
 9iMVRE1fEA6VWsj5vuZQZ1IvalfvDfZSqCPffH3E92QsgU4g5w20AccyWWbR
 MyELiUALaJ3MmqWkP2QDAxauFhHp8Uw1L1kA1rh.IllbvGagjWl5Fu.LQg.D
 mBoBNkKOJfH0j48il5SPM.46eRDJHV.j88Wc8C2DQjrO6zQQGuwkxZQOEpeq
 OW9B2.J1qXNgFaZ6Svnc0mURoVU_YqgPG9PyTdUp_VxxC_xow
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F1345DB.8040303@schaufler-ca.com>
Date: Sun, 15 Jan 2012 13:32:11 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
        alan@lxorguk.ukuu.org.uk, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
References: <1326411506-16894-1-git-send-email-wad@chromium.org> <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com> <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com> <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com> <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com> <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com> <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com> <4F133423.5070007@schaufler-ca.com> <CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
In-Reply-To: <CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2012 12:59 PM, Andrew Lutomirski wrote:
> On Sun, Jan 15, 2012 at 12:16 PM, Casey Schaufler
> <casey@schaufler-ca.com>  wrote:
>> On 1/14/2012 12:22 PM, Linus Torvalds wrote:
>>> And yes, I really seriously do believe that is both safer and simpler
>>> than some model that says "you can drop stuff", and then you have to
>>> start making up rules for what "dropping" means.
>>>
>>> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
>>> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
>>> that no, we should not even allow that. It's simply all too "subtle".
>>
>> I am casting my two cents worth behind Linus. Dropping
>> privilege can be every bit as dangerous as granting privilege
>> in the real world of atrocious user land code. Especially in
>> the case of security policy enforcing user land code.
> Can you think of *any* plausible attack that is possible with my patch
> (i.e. no_new_privs allows setuid, setresuid, and capset) that would be
> prevented or even mitigated if I blocked those syscalls?  I can't.
> (The sendmail-style attack is impossible with no_new_privs.)

I am notoriously bad at coming up with this sort of example.
I will try, I may not hit the mark, but it should be close.

The application is running with saved uid != euid when
no-new-privs is set. It execs a new binary, which keeps
the saved and effective uids. The program calls setreuid,
which succeeds. It opens the saved userid's files.

Some people reading this will say this is expected and
appropriate behavior, and others will say it's an exploit
under sandbox conditions. Those in the latter group can
point out that blocking setreuid() would prevent what
they consider an exploit. Those in the former group will
say blocking the setreuid would introduce a denial of
service that could lead to an exploit if the program is
poorly written.

Because the correctness of the behavior is ambiguous
(to me at least) when no_new_privs is set I argue that
we shouldn't have it. If we are going to have it my
feeling is that it should be as draconian as possible.
Because you can't always tell if state A is "more"
privileged than state B, any change between A and B has
to be treated as an escalation.

>
> Also, how would you even block setuid(2) in a non-confusing manner?
> The semantics and error returns are already such a disaster than it's
> barely worth it for anything to check the return value.
>
>> This even more important in environments that support fine
>> granularity of privilege, including capabilities and SELinux.
>> Under SELinux a domain transition can increase, decrease or
>> completely change a process' access rights and there is really
>> no way for the kernel to tell which it is because that's all
>> encoded in the arbitrary SELinux policy. Smack does not try
>> to maintain a notion of hierarchy of privilege, so the notion
>> of any change being equivalent to any other is in line with
>> the Smack philosophy.
>>
> My patch does not (barring bugs) allow selinux domain transitions.  I
> certainly think that all security transitions that vary across
> distributions should be blocked by no_new_privs.
>
> --Andy
>

