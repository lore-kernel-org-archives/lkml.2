Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0JZG1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:27:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57073 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0JZG07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:26:59 -0400
Date: Tue, 26 Oct 2010 08:26:53 +0200
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
Message-ID: <20101026062653.GA27411@liondog.tnic>
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
 <20101025202344.GC13652@liondog.tnic>
 <AANLkTi=DEmss+3uX_5uw=VJDY9+cFPayjQkCQHa+r+Ye@mail.gmail.com>
 <20101025215132.GA23427@liondog.tnic>
 <AANLkTi=pJFUWusDNrwQA8bWYy4q5QZBHxkbikZGKvHLY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=pJFUWusDNrwQA8bWYy4q5QZBHxkbikZGKvHLY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 04:35:43PM -0700, Tony Luck wrote:
> On Mon, Oct 25, 2010 at 2:51 PM, Borislav Petkov <bp@alien8.de> wrote:
> > Concerning fatal errors, take a look at drivers/edac/mce_amd.(c|h)¹ -
> > this is not in arch/x86/ and still decodes MCEs in the kernel. And it
> > works fine - it even helped in several cases where people simply read
> > their serial console/dmesg and didn't have to collect it first and run
> > it through some tool to understand which functional unit in the CPU is
> > mchecking.
> 
> That looks neat ... but end-users seem to have some conflicting requirements
> here. Your uses seem to like it but the LLNL folks at the S.F. meeting said
> that solutions that involved looking at console logs from thousands
> of machines in a cluster were not acceptable.
> 
> I doubt very much if any end-user cares which unit *within* a cpu
> failed (their replaceable unit is the whole of the cpu). So much of
> your driver could be replaced with: printk("CPU%d is bad\n", cpu);

Yeah, nobody said this is finished. The next step is using perf
infrastructure to convey those decoded errors to userspace, say, to a
ras daemon or similar which can do all sorts of reporting, statistics,
policy decisions, injection, paint graphs, whatever...

I sent out two patchsets as an rfc already and am working
on the 3rd one so we're getting there. Here's the last one:
http://kerneltrap.org/mailarchive/linux-kernel/2010/8/6/4603847

Also, I'm open to all suggestions on how to make it more usable and
user-friendly.

Thanks.

-- 
Regards/Gruss,
    Boris.
