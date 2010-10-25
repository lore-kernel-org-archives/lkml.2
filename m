Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab0JYUXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:23:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55815 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab0JYUXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:23:48 -0400
Date: Mon, 25 Oct 2010 22:23:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025202344.GC13652@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Borislav Petkov <petkovbb@googlemail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025092557.GA11544@elte.hu>
 <AANLkTi=2SVT1M+nDZUB7EB05jh+tsuKcew_t66QORrwb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=2SVT1M+nDZUB7EB05jh+tsuKcew_t66QORrwb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 10:14:52AM -0700, Tony Luck wrote:
> On Mon, Oct 25, 2010 at 2:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > drivers/acpi/apei/ overlaps and duplicates drivers/edac/. We dont want two
> > facilities, two ABIs, two sets of behavior. erst-dbg even defines a /dev node with
> > two ioctls, and a debugfs file to read/write records ...
> 
> As mentioned above these 4-letter names from from the ACPI specification. ERST
> is perhaps the dumbest name of them all - "Error Record Serialization Table" is
> ACPI-speak for platform level non-volatile memory.  This code simply provides
> a mechanism for Linux to stash some information in nvram before the system is
> reset, and to retrieve it after the reboot.
> 
> The naming could be better - but I don't see any overlap with EDAC here.

You may be right but what we actually want is a consistent RAS
infrastructure. Didn't you point out at the last edac meeting in Boston
that concerning RAS Linux were in the stone ages? (at least this is what
I remember reading).

What we should do is put all that post-system-reset error info, ECC
errors mapping to DRAM devices, L3 cache index manipulation based on
excessive errors - you name it - together and stick it in ras/ or
drivers/ras or whatever. And all with a nice and easy to use userspace
tool on top.

Now it looks like a wart on arch/x86/ which truly doesn't belong there.
And I don't buy all that crap that it can't be done right.

Thanks.

-- 
Regards/Gruss,
    Boris.
