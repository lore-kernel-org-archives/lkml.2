Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0KTX6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 18:58:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab0KTX6L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 18:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
 <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
 <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
 <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
 <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com> <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Nov 2010 15:57:40 -0800
Message-ID: <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. This seems to have gotten bounced by a bad smtp setup here
locally. Sorry if you get it twice..

            Linus

On Sat, Nov 20, 2010 at 8:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 19, 2010 at 11:11 PM, huang ying
> <huang.ying.caritas@gmail.com> wrote:
>> On Sat, Nov 20, 2010 at 10:15 AM, Linus Torvalds
>>> Bah. Many machine checks _were_ software errors. They were things like
>>> the BIOS not clearing some old pending state etc.
>>
>> I think the BIOS error should be reported to hardware vendor instead
>> of software vendor. Do you think so?
>
> They won't care. The only people who care are _us_. Software people.
> We may be able to work around a broken BIOS.
>
> Also, sometimes the machine checks are really our fault. Read the
> Intel documentation on page tables etc, it says that you can get
> machine checks if you inconsistent page attributes. Or maybe that was
> AMD.
>
> The point is, it's simply not _true_ that hardware errors are always a
> hardware bug. It never has been.
>
> And it's not _true_ that people care about them the same way. The only
> thing that is true is that a sysadmin wants to see them, but he wants
> to see them _exactly_ the same way he wants to see a kernel oops etc.
>
>>> IT HAS NOTHING WHAT-SO-EVER TO DO WITH HOW OFTEN THE ERRORS HAPPEN.
>>
>> Because some external cause like cosmic rays and electromagnetic
>> interference can cause hardware errors too. We need error counting to
>> distinguish between external caused hardware errors and real hardware
>> errors.
>
> Do you really think that a system administrator is too stupid to count to three?
>
> Yes, admittedly I've met some people like that. But no, "cosmic rays"
> do not change anything.
>
> People have had this for _ages_ with simple parity-protected RAM (with
> ECC just being another fancier form of it). People _know_.
>
> If you get an ECC report randomly once a month per machine, you know
> it's something like cosmic rays.
>
> And if you notice that _one_ of your machines gets five ECC errors per
> minute, you know it's something else. As an MIS person you might still
> decide keep the dang thing, because it's just the print server for the
> admin people, and you know that your paycheck is handled by another
> machine. But if it's the Quake server, you realize that it needs to be
> replaced _today_.
>
> See? That's not the kind of rational decision that some automated
> program can make.
>
> It really is that simple. No amount of "automatic counting" will ever
> help you. Quite the reverse. It will just complicate the thing.
>
>> So, do you agree that we need some tool oriented interface in addition
>> to printk?
>
> No. Any such tool will just _hide_ the information from the MIS people
> who don't even know about it.
>
> But you could certainly make a simple agreed-upon format. We have BUG:
> and WARNING: in the kernel logs. Why not HWPROBLEM: or something?
>
> MIS people love their perl scripts. And the people who can't do perl
> can still use the standard log tools.
>
>                               Linus
>
