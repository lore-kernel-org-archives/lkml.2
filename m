Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2LJTN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:13:29 -0500
Received: from smtp109.biz.mail.bf1.yahoo.com ([98.139.244.33]:32765 "HELO
	smtp109.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751850Ab2LJTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:13:23 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NvDdb9sVM1k5TD4LtQXm_Evv.tK3aay55.sUUzOfwgH2_b7
 rVe2HaEeOZHkppUBiUB7oKexhBdkrLGaYtEHfTixJa6nAvK8yYLmcSK7uwZ9
 bg3UpNGzn1lCWcGOkENei3JCMh_cBN5t21OOm6b.HQ28QfhD5ES5KGNqSHJm
 DPVQkulv6Cf5sb6kG5t4khv4USbw_P3Dgt3fAEeSCnfwOp37460fYMGLVmGT
 H6GoBcSNAGIb22YfWb37qtsGRHriepJdhoXViinb_Bd.szYFjdBS2gGkWlJ_
 3Tkk0RFGERDa2x_KGdfgKFPYzq7nCurgHL29uw.9qMCaX8MXvj2er0_bLAzB
 0dWIHLXTiFxUqIPvVwPTmjxv5jB55WXsVgtp6.H9LxQvJvLCKunUvmpdPhmH
 noaedebrYEsFOuzXjAfQRJL3Ws.tUI3gWwrVbyWm2niiuV3nvA1b2mSj3jPq
 InqRqm_wuFe.BGc8kouPjb55F77Ab7rco.o_MBc3WlysbhdkeWvNPrKCQril
 KpvU0AQbJG07rFc5pDzaK6Po1A98UuDeqwiM0sMahRnMwIz6hgur5oi3oRbs
 dA7FF67kB4Zn_ARE7Q4zAM9cIa68-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50C6345C.8040804@schaufler-ca.com>
Date: Mon, 10 Dec 2012 11:13:32 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Serge Hallyn <serge.hallyn@canonical.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com> <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com> <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com> <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com> <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com> <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com> <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com> <20121210145950.GC8137@sergelap> <50C603F8.6070401@schaufler-ca.com> <CALCETrWNboHVRm_aZ-Fvqri6PW3C4FPfuLLe3-8q7+-vgEP2nw@mail.gmail.com>
In-Reply-To: <CALCETrWNboHVRm_aZ-Fvqri6PW3C4FPfuLLe3-8q7+-vgEP2nw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 10:12 AM, Andy Lutomirski wrote:
> On Mon, Dec 10, 2012 at 7:47 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> Put an ACL on the program file.
>> If you want different users to run with different privilege
>> make two copies of the program and give them different
>> ACLs and cap sets.
>> If your program is so big that making a copy is a disk space issue
>> it is too big to have privilege.
>> If you can't deal with having the have different paths for different
>> users write a shell script that redirects to the correct version
>> based on user id.
>>
>> This is not rocket science. The kernel shouldn't be crammed
>> with mechanism and complexity just because disto/"OS"/site
>> developers can't be bothered with learning how the existing
>> facilities work.
> I agree.  But I think that the existing capability support is already
> overcomplicated, and I'd rather make it simpler.  Sticking the
> complexity in userspace is too difficult right now because it requires
> fiddling with the file inheritable mask.
>
> I think that the Windows approach is worth looking at.  See here:
>
> http://msdn.microsoft.com/en-us/library/windows/desktop/aa375202%28v=vs.85%29.aspx
>
> In the Windows model, each capability ("privilege") can be in one of
> three states: enabled (i.e working right now),

Effective

>  permitted (i.e.
> available upon request but not currently enabled),

Permitted

> or removed
> (disallowed to this process and all of its children).

~Inherited

> Permitted
> privileges are always inherited when a child process is created.
>
> This is *way* simpler than Linux's model, and it works just fine*.

I see a different set of complications, and Windows never had
a setuid bit to contend with. God created the universe in seven
days, but then, He didn't have an installed base.

