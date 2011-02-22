Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1BVSnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:43:31 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:7532 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BVSna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:43:30 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/6] x86: Minimize initial e820 messages
Date: Tue, 22 Feb 2011 11:43:10 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-26-generic; KDE/4.4.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024705.695093866@gulag1.americas.sgi.com>
In-Reply-To: <20110219024705.695093866@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221143.10718.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 18, 2011 07:47:07 pm Mike Travis wrote:
> Minimize the early e820 messages by printing less characters
> for the address range as well as abbreviating the type info
> for each entry.

> +			pr_info("%s: %Lx+%Lx (%s)\n", who,
> +			       (unsigned long long) e820.map[i].addr,
> +			       (unsigned long long) e820.map[i].size,
> +			       e820_types(e820.map[i].type));

If we're going to change the way we print E820 ranges, I think
we should make them consistent with the way we handle %pR, e.g.,
use something like this:

    "%s: [mem %#018Lx-%#018Lx]"

This is a little different because %pR wouldn't make the field
so wide, but when we discussed this earlier, keeping the table
alignment was thought to be important.  That discussion starts
here: https://lkml.org/lkml/2010/9/22/248

Same comment applies to the update, remove, PCI gap (which
your patch currently doesn't touch), and EFI output.

I know this kind of derails the whole "remove characters" point
of your patch (and I support that in principle), but I do think
consistency is important, too.  We have too many different ways
of printing the same information.

Bjorn
