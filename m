Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1CJPi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:38:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1CJPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:38:28 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=4OsHwD4v7OsDvIFBCxkA:9 a=lUa13NhJZEH-Ow5LvWcA:7 a=OiWj4KSeYlYySJGEBM-SAcYOQqwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=TqnX0QawOnx04QYx:21 a=0aJmEmo346b1NsVD:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <1299728191.15854.319.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 10:38:24 -0500
Message-ID: <1299771504.15854.347.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 09:11 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
> > > Hi,
> > > 
> > > Re-fresh of updates against latest -tip tree.
> > 
> > Thanks Jason,
> > 
> > I started looking at them, I should have comments tomorrow (if I have
> > any comments ;)
> > 
> > > 
> > > I've tried to split this update up somewhat, but I've only succeeded to split
> > > out the dynamic debug bits. The interface changes and re-write are quite
> > > intertwined.
> > > 
> > > I believe this update should address all the comments from the previous posting
> > > except for Mathieu's request for a section of jump label pointers that point to
> > > the jump label structures (since the compiler might leave gaps in the jump label
> > > structures).
> > 
> > The jump label structures is a list of 3 pointers, correct? I doubt that
> > gcc would place any holes in it as they are all aligned by natural word
> > size.
> > 
> 
> Hi Steven,
> 
> Can you explain what would prevent gcc from aligning these 3 pointers
> (total of 24 bytes on 64-bit architectures) on 32-bytes ? Also, could
> you point out what would refrain the linker from aligning the start of
> object sections on the next 32-bytes (thus power of two) address
> multiple ?

Maybe it would be just easier to add another long ;)

Seriously, it would. Then it would be 32 bytes on 64bit and 16 bytes on
32bit. Then I guess we can have our guarantee without doing a large
change to have this indirect pointer and still waste sizeof(long) bytes
in having it.

Just insert a long "Reserved" word.

-- Steve

> 
> I think we need to be a bit more strict in our interpretation of what
> guarantee gcc/ld provide and don't provide with respect to section and
> structure alignment.
> 
> As it stands now, the section alignment of jump labels looks half-broken
> on most architectures, and this *is* a big deal. I would really like to
> see a patch for this (it can be a separate patch) going in for .39.
> 
> Thank you,
> 
> Mathieu
> 


