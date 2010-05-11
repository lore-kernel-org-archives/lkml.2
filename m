Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0EKSUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:20:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285Ab0EKSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:20:15 -0400
Date: Tue, 11 May 2010 11:17:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <20100511175904.GA18797@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005111107020.3711@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <20100507061203.GA8779@srcf.ucam.org> <alpine.LFD.2.00.1005071402080.901@i5.linux-foundation.org> <20100507211331.GA28906@srcf.ucam.org>
 <alpine.LFD.2.00.1005071418200.901@i5.linux-foundation.org> <20100507213600.GC28906@srcf.ucam.org> <20100511172543.GA17868@srcf.ucam.org> <alpine.LFD.2.00.1005111031260.3711@i5.linux-foundation.org> <20100511175904.GA18797@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 May 2010, Matthew Garrett wrote:
> 
> I see Windows write the SCI_EN bit without reading it first and without 
> calling the ACPI enable SMM function.

Hmm. So presumably Windows doesn't even do them bit-by-bit, but simply 
does a "restore PM1 Control register value" on resume.

And I guess it probably does the same for the PM1_ENABLE register and the 
PM2 control registers too?

Just restoring the whole register values _does_ sound a lot simpler than 
worrying about individual bits.

		Linus
