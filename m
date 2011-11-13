Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1KMChm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 21:37:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:50086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1KMChl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 21:37:41 -0500
Date: Sat, 12 Nov 2011 18:37:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INVLPG Instruction
Message-ID: <20111112183735.333b747f@infradead.org>
In-Reply-To: <CALKntY3ivYxMzuaq0BwXO_uX=w+_wneaNV6zCGo0ZeAZWm54Sw@mail.gmail.com>
References: <CALKntY3ivYxMzuaq0BwXO_uX=w+_wneaNV6zCGo0ZeAZWm54Sw@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Nov 2011 19:59:44 -0500
Xin Tong <xerox.time.tech@gmail.com> wrote:

> Hello
> 
>   When a process has a page fault and Linux swaps out a page ( no more
> free page ) from another process and give it to the page-faulting
> process. Typically a INVLPG is used to invalidate entries  in the TLB.
> I would like to know whether INVLPG is global ( i.e. across all cores
> )? How does the process which Linux stole the page from get informed (
> how is its tlb invalidated) ?

invlpg is not "global" in the way you mean it (nor in the sense of
"global pte's").
The kernel will do an IPI to the processors that have a possibility to
have this page in the TLB and do a local flush there.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
