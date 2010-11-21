Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0KUAm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:42:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37044 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0KUAmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x4iWVmaJl7Xw1g34mNMoZijwPw9AU4K9FYdRQAl6B6lO/oUl+qOrQMc/EgjXsQ8d47
         qX/uWePf5rtb8y+4wDKdgEp798xsAEUtwlgYVROUBxGQ4cE8TGJOiAgV5s/pN6BzK5dj
         704lfNL4E35i3hA4yxopZKuxGwPDDUh2PxH+o=
MIME-Version: 1.0
In-Reply-To: <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
	<AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
	<AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
	<AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
	<AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
	<AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>
Date: Sun, 21 Nov 2010 08:42:52 +0800
Message-ID: <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 7:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
[...]
> On Sat, Nov 20, 2010 at 8:04 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Fri, Nov 19, 2010 at 11:11 PM, huang ying
>> <huang.ying.caritas@gmail.com> wrote:
>>> On Sat, Nov 20, 2010 at 10:15 AM, Linus Torvalds
>>>> Bah. Many machine checks _were_ software errors. They were things like
>>>> the BIOS not clearing some old pending state etc.
>>>
>>> I think the BIOS error should be reported to hardware vendor instead
>>> of software vendor. Do you think so?
>>
>> They won't care. The only people who care are _us_. Software people.
>> We may be able to work around a broken BIOS.
>>
>> Also, sometimes the machine checks are really our fault. Read the
>> Intel documentation on page tables etc, it says that you can get
>> machine checks if you inconsistent page attributes. Or maybe that was
>> AMD.
>>
>> The point is, it's simply not _true_ that hardware errors are always a
>> hardware bug. It never has been.
>>
>> And it's not _true_ that people care about them the same way. The only
>> thing that is true is that a sysadmin wants to see them, but he wants
>> to see them _exactly_ the same way he wants to see a kernel oops etc.
>>
>>>> IT HAS NOTHING WHAT-SO-EVER TO DO WITH HOW OFTEN THE ERRORS HAPPEN.
>>>
>>> Because some external cause like cosmic rays and electromagnetic
>>> interference can cause hardware errors too. We need error counting to
>>> distinguish between external caused hardware errors and real hardware
>>> errors.
>>
>> Do you really think that a system administrator is too stupid to count to three?

Yes. They can. But people like tools. For example I can calculate, but
sometimes I use a calculator. :)

>> Yes, admittedly I've met some people like that. But no, "cosmic rays"
>> do not change anything.
>>
>> People have had this for _ages_ with simple parity-protected RAM (with
>> ECC just being another fancier form of it). People _know_.
>>
>> If you get an ECC report randomly once a month per machine, you know
>> it's something like cosmic rays.
>>
>> And if you notice that _one_ of your machines gets five ECC errors per
>> minute, you know it's something else. As an MIS person you might still
>> decide keep the dang thing, because it's just the print server for the
>> admin people, and you know that your paycheck is handled by another
>> machine. But if it's the Quake server, you realize that it needs to be
>> replaced _today_.
>>
>> See? That's not the kind of rational decision that some automated
>> program can make.

We just provide the mechanism in the automated program, let MIS person
fill in the policy. They can setup the automated program in print
server just email them if error exceed threshold, and setup the Quake
server to hot-remove the error DIMM if error exceed threshold.

Some server machine can do more than just replace the whole machine.
Some hardware components like DIMM, CPU, etc can be hot-removed, these
can be done by tool instead of human. We can trigger these operations
automatically in a more timely way if we have a automated tools. After
error exceed threshold, administrator may need several hours to notice
it, but the automated tools can trigger it almost immediately.

And the user space tool can help us to identify the error hardware
components too. For example, there is no common way to identify which
DIMM goes error from the physical address reported by hardware.
Sometimes some very tricky method is used, EDAC people use a
motherboard specific table to map to the DIMM slot. On some machine,
SMBIOS table can be used, but on some other machine, SMBIOS table is
just crap. I think it is not good to do all these dirty and maybe
machine specific work in kernel.

>> It really is that simple. No amount of "automatic counting" will ever
>> help you. Quite the reverse. It will just complicate the thing.
>>
>>> So, do you agree that we need some tool oriented interface in addition
>>> to printk?
>>
>> No. Any such tool will just _hide_ the information from the MIS people
>> who don't even know about it.

I don't want to hide the information from the MIS people with the
tool. I want to show the information to MIS people in a better way.
For example, we can email MIS people under some situation. And we can
implement a SNMP agent inside the tool, so that the MIS people can
monitor the hardware status remotely. This can be integrated with the
MIS people's other administrator tool.

>> But you could certainly make a simple agreed-upon format. We have BUG:
>> and WARNING: in the kernel logs. Why not HWPROBLEM: or something?

There is a "[Hardware Error]: " prefix for printk in kernel. We can
use that to mark hardware errors. It is already used by Machine Check.

>> MIS people love their perl scripts. And the people who can't do perl
>> can still use the standard log tools.

Perl scripts are just another kind of user space tools for hardware
errors. We just want to write a better tool for them with the help of
a tool oriented error reporting interface.

Best Regards,
Huang Ying
