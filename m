Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2LJPq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:46:57 -0500
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:32275 "HELO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753505Ab2LJPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:46:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VbookyUVM1kFTzju7u2oSzaiUPMFQq7k7xRFok5Gyt0Ogmt
 ELc4IljYdmtJLKRpX2NmCpwD6Tl53BV0LAIkzM7nRa6Z5h_95fmVIL2Ps62T
 Y4iPm9wmHuUl_iC1FajRMIsGXfNSGzVNsLkkt2oCx0PL2f_EC1Am9oBdKmTi
 PeP0XqDUHfTdtHv3XTRw6BW.joIrmDC9_7nn0Y.EAkoUV3ddmXCSw5mKxf8h
 gacD2PN2gqzirBOMowtma_coXroIMMApI_0duUVhGuy6M.keA6LfLsm4vzCe
 OVB6qO.l2eDETK0B_JOPpa0xki.PlTkXWO_iOgEoAYnD8TMvQ_WNaDb.rKBk
 IddhdVBEywug3j5yzO_hkfCzXKvIzSCRFwpqLRsh42q8nzXz0lfPJIEkqASE
 B2tQ82SZLoRkMnBCsKM1XDypjBPTh6mVJB.Sc8t9CGBTLTyjIivpEQfQ5HQ2
 WylB1
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50C603F8.6070401@schaufler-ca.com>
Date: Mon, 10 Dec 2012 07:47:04 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Andy Lutomirski <luto@amacapital.net>,
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
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com> <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com> <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com> <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com> <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com> <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com> <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com> <20121210145950.GC8137@sergelap>
In-Reply-To: <20121210145950.GC8137@sergelap>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 6:59 AM, Serge Hallyn wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
>> doesn't mean anything.  Is he authorized to back things up to
>> encrypted storage?
> We're talking about privileges at the kernel level here, and there is
> no way this could be expressed at that level.
>
> Higher level tools could/should certainly be exposing things at this
> level.
>
> BUT
>
> You *are* doing a good job of making me feel that we should have
> per-user fI xattrs or acls.  Sudo is popular because people like to say
> "user joe can run foo with privilege".  Most people will never want to
> be bothered to say "user joe can run foo with CAP_XYZ" (versus "as
> root"), but I do think we could get programs/packages to do that.

Put an ACL on the program file.
If you want different users to run with different privilege
make two copies of the program and give them different
ACLs and cap sets.
If your program is so big that making a copy is a disk space issue
it is too big to have privilege.
If you can't deal with having the have different paths for different
users write a shell script that redirects to the correct version
based on user id.

This is not rocket science. The kernel shouldn't be crammed
with mechanism and complexity just because disto/"OS"/site
developers can't be bothered with learning how the existing
facilities work.

I frequently get requests to make changes to the way Smack
controls access that can easily be achieved using users and
groups. It's amazing how often people seem to forget that
Linux has security mechanisms other than the one that they
think is the cat's pajamas.

>
> Note that another difficulty here likes in the age-old, as yet
> unanswered imo, question of "how do I easily figure out what caps I need
> to run my program."  A few years ago I pointed to this (perhaps in
> mostly private emails, don't recall) as something to be solved, but
> the solution escapes me.

The audit trail is your friend. If it doesn't tell you what
capabilities are required that you don't have, it should.

Unfortunately, the Linux (formerly Unix) security policy into
which the capabilities mechanism was retrofit is implementation
derived. Without understanding how the Linux security system,
with users and groups and LSMs and all works it's impossible
to just guess and even if you do understand all that there is
going to be lots of environmental context to deal with.
Sorry, there's no magic wand.

If I had it to do over there would be many fewer capabilities.
Please reread that. I said fewer. You need something that would make
SELinux policy look small to break out a consistent fine granularity,
so I say go consistently coarse. 

>
> -serge
>

