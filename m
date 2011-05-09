Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1EIVJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:09:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1EIVJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:09:02 -0400
Date: Mon, 9 May 2011 22:08:41 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
Message-ID: <20110509210841.GB9253@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz> <4DC7D37F.9040308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC7D37F.9040308@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 01:43:59PM +0200, Zdenek Kabelac wrote:
> Dne 9.5.2011 13:01, Mikulas Patocka napsal(a):
> > So, when LVM used mlockall, it consumed >100MB memory and it caused 
> > out-of-memory problems in system installers.

The way glibc and some distros have implemented locales makes mlockall()
quite useless for many purposes now in practice IMHO.  We discussed the
options at the time and wrote the extra code to implement the only
solution we were offered.

(1) There was no possibility of some distros not using a single locale
database (reasons: optimisation and packaging convenience);
(2) there was no possibility of glibc providing a mechanism to unmap the
locale database (if you reset your locale to the default glibc will not
unmap the file and indeed doesn't rule out doing something similar with
other files in future - these are glibc internals and it's none of our
business).

Alasdair


