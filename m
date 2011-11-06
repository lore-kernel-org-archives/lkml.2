Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1KFUFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1KFUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:05:33 -0500
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Date: Sun, 06 Nov 2011 15:05:27 -0500
In-Reply-To: <CA+55aFwodK9Z7cUu4bdhmOcR2L3R_fBYdTyJv6iQKcYFrH2Xew@mail.gmail.com>
References: <1320179267.14825.107.camel@deneb.redhat.com>
	 <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
	 <1320529182.14081.78.camel@deneb.redhat.com>
	 <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
	 <1320593057.14081.107.camel@deneb.redhat.com>
	 <CA+55aFwodK9Z7cUu4bdhmOcR2L3R_fBYdTyJv6iQKcYFrH2Xew@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1320609928.2382.12.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-06 at 11:07 -0800, Linus Torvalds wrote:
> >
> > I think the best counter argument is that it leads to paddr != vaddr
> > in the case of NOMMU with a non-zero memory base. My view is that in
> > all NOMMU cases, physical and virtual addresses should be the same.
> > Otherwise, you end up breaking drivers which need to pass physical
> > addresses to devices.
> 
> That's a totally insane argument.

Not *totally* insane. Forget the last sentence. You're right that its a
driver problem. Creating a physical address space separate from the
"virtual" space on a NOMMU arch where the hw uses a one-to-one mapping
seems a long way to go. My point here is that the simplest NOMMU case is
paddr == vaddr. Right now, the generic headers are broken in that regard
for hardware that maps RAM at a non-zero address.

So, okay. Let's have some more discussion among more people. There is
certainly more than one approach to fix the currently broken bits and I
sure don't claim to have the one true way. I just want to do what needs
to be done to make the port acceptable for upstream inclusion.

--Mark


