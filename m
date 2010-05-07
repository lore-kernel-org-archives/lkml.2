Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0EGXXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:23:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab0EGXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:23:14 -0400
Date: Fri, 7 May 2010 16:21:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <201005080117.23760.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005071618410.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <201005080039.45533.rjw@sisk.pl> <alpine.LFD.2.00.1005071600030.901@i5.linux-foundation.org> <201005080117.23760.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 May 2010, Rafael J. Wysocki wrote:

> On Saturday 08 May 2010, Linus Torvalds wrote:
> > 
> > On Sat, 8 May 2010, Rafael J. Wysocki wrote:
> > 
> > > On Friday 07 May 2010, Linus Torvalds wrote:
> > > > 
> > > > Btw, why don't we just force the SCI_EN by hand?
> > > 
> > > Because there are boxes that are broken right away by this.
> > > 
> > > I have one on my desk in front of me. :-)
> > 
> > Also if we check whether it was already set before?
> 
> Yes.

I don't think you understood the question.

If we check whether it was already set before, we wouldn't _do_ it by 
hand.

> > The thing is, if that bit is clear (_after_ we've done the regular ACPI 
> > setup), the box can't work correctly as far as I know.
> 
> That's correct.  But on that particular box acpi_enable() is necessary to
> make things work.  Setting SCI_EN by hand makes it hang solid.

Let me explain what I think we should do with actual code:

	acpi_enable();
	if (test_if_that_f_cking_bit_still_isnt_set)
		set_it_by_hand();

wouldn't that work on your box? The acpi_enable() seems to work for you, 
so it wouldn't actually ever set it by hand. 

But the problem is that on a number of boxes, acpi_enable() apparently 
doesn't do what it should do. Because the stupid BIOS "knows" it is 
already in ACPI mode, but it forgot to actually set the bit!

			Linus
