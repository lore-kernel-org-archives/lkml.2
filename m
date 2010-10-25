Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab0JYXfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:35:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37756 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0JYXfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ADIhi7pF0jb0cHNTce86PpUMSkAqnU98Vs7JHwocYv9I7SIto5S30QR5rEdEOHOvsZ
         ZSBy4LNuhUPWnYYogJENDqNhSJguMlbX2EgZGMn+889/Svns04132Bj8aIZFs34nHd2w
         ezRrk+8zwIPpB/ikREVTb6i6WOCMKjgmfH+qw=
MIME-Version: 1.0
In-Reply-To: <20101025215132.GA23427@liondog.tnic>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
	<1287992610-14996-10-git-send-email-ying.huang@intel.com>
	<20101025084553.GA27119@elte.hu>
	<1287997112.2862.322.camel@yhuang-dev>
	<20101025092557.GA11544@elte.hu>
	<AANLkTi=2SVT1M+nDZUB7EB05jh+tsuKcew_t66QORrwb@mail.gmail.com>
	<20101025202344.GC13652@liondog.tnic>
	<AANLkTi=DEmss+3uX_5uw=VJDY9+cFPayjQkCQHa+r+Ye@mail.gmail.com>
	<20101025215132.GA23427@liondog.tnic>
Date: Mon, 25 Oct 2010 16:35:43 -0700
Message-ID: <AANLkTi=pJFUWusDNrwQA8bWYy4q5QZBHxkbikZGKvHLY@mail.gmail.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 2:51 PM, Borislav Petkov <bp@alien8.de> wrote:
> Concerning fatal errors, take a look at drivers/edac/mce_amd.(c|h)¹ -
> this is not in arch/x86/ and still decodes MCEs in the kernel. And it
> works fine - it even helped in several cases where people simply read
> their serial console/dmesg and didn't have to collect it first and run
> it through some tool to understand which functional unit in the CPU is
> mchecking.

That looks neat ... but end-users seem to have some conflicting requirements
here. Your uses seem to like it but the LLNL folks at the S.F. meeting said
that solutions that involved looking at console logs from thousands
of machines in a cluster were not acceptable.

I doubt very much if any end-user cares which unit *within* a cpu
failed (their replaceable unit is the whole of the cpu). So much of
your driver could be replaced with: printk("CPU%d is bad\n", cpu);

-Tony
