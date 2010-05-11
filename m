Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0EKRZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:25:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38962 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab0EKRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:25:53 -0400
Date: Tue, 11 May 2010 18:25:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Message-ID: <20100511172543.GA17868@srcf.ucam.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <20100507061203.GA8779@srcf.ucam.org> <alpine.LFD.2.00.1005071402080.901@i5.linux-foundation.org> <20100507211331.GA28906@srcf.ucam.org> <alpine.LFD.2.00.1005071418200.901@i5.linux-foundation.org> <20100507213600.GC28906@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507213600.GC28906@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:36:00PM +0100, Matthew Garrett wrote:
> On Fri, May 07, 2010 at 02:21:08PM -0700, Linus Torvalds wrote:
> > Well, is there any reason to have 'set_sci_en_on_resume' at all then?
> 
> I'd hope not, but it depends on what Windows does on resume. If it 
> doesn't do the SMM call and just does the register write instead, then 
> it may be that some machines are on that list because the SMM call 
> breaks them rather than because they need the register to be set by 
> hand. I'm planning on instrumenting it to check, but haven't had time to 
> do so yet.

I've now checked the behaviour of Windows. It turns out that it never 
makes the ACPI enable SMM call on resume. This is consistent with 
http://bugzilla.kernel.org/show_bug.cgi?id=13745 which shows a bug 
being introduced by us making the enable call in the first place. 
Merging my patch and removing the blacklist would re-break these 
machines. Instead, we should just unconditionally set SCI_EN since this 
is the tested configuration. I'll send a followup patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
