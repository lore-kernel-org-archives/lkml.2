Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2J2LFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:05:32 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52258 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2J2LF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:05:27 -0400
Date: Mon, 29 Oct 2012 12:05:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] s390: Add pmd_mknotpresent()
Message-ID: <20121029110519.GA22569@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
 <20121018182642.2a541275@thinkpad>
 <20121028131014.GA10754@gmail.com>
 <20121029084956.12b512e6@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029084956.12b512e6@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Sun, 28 Oct 2012 14:10:14 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > There's a related problem on s390: other THP implementations 
> > have pmd_mknotpresent() while s390 not, resulting in:
> > 
> >   mm/huge_memory.c:1543:2: error: implicit declaration of function 'pmd_mknotpresent'
> > 
> > The (untested!) patch below adds the s390 version of this 
> > method.
> > 
> > Gerald, Martin, did I get the S390 details right?
> 
> This won't work I'm afraid. S390 uses invalid bits which need 
> to be set to make an entry not present. Just setting the 
> _SEGMENT_ENTRY_INV bit is not good enough either, there is 
> _HPAGE_TYPE_NONE to consider. The patch to fix this for 
> pmd_none & pmd_present just got added to the s390 tree on 
> kernel.org:
>
> https://git.kernel.org/?p=linux/kernel/git/s390/linux.git;a=shortlog;h=refs/heads/fixes
> 
> Now, if pmd_mknotpresent is supposed to make the entry invalid 
> so that pmd_present will return false the function needs to do 
> two things, 1) set the _SEGMENT_ENTRY_INV bit, and 2) clear 
> the _SEGMENT_ENTRY_RO bit.

Would be nice if you could send me your suggested 
pmd_mknotpresent().

(Writing it into the email would be enough, I can turn it into a 
patch - but a patch would be welcome as well.)

Thanks,

	Ingo
