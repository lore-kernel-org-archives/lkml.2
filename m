Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2BBQ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:28:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2BBQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:28:32 -0500
Date: Thu, 2 Feb 2012 17:28:30 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Aldy Hernandez <aldyh@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Torvald Riegel <triegel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
In-Reply-To: <874nv9qlau.fsf@houston.quesejoda.com>
Message-ID: <Pine.LNX.4.64.1202021726020.25409@wotan.suse.de>
References: <20120201151918.GC16714@quack.suse.cz>
 <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb> <20120201194025.GG6148@sunsite.ms.mff.cuni.cz>
 <CA+55aFzVWjqcs1zRF-93_9yHRDS-YgmpgFTzACw6HQ-059U06Q@mail.gmail.com>
 <20120201201631.GW18768@tyan-ft48-01.lab.bos.redhat.com>
 <CA+55aFwcLpD2Cw5VxZ3ym66QBDAeDam3-hprivrC+keUMXJOtw@mail.gmail.com>
 <874nv9qlau.fsf@houston.quesejoda.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2 Feb 2012, Aldy Hernandez wrote:

> > Seriously - is there any real argument *against* just using the base 
> > type as a hint for access size?
> 
> If I'm on the hook for attempting to fix this again, I'd also like to 
> know if there are any arguments against using the base type.

Sure.  Simplest example: struct s {int i:24;} __attribute__((packed)).

You must access only three bytes, no matter what.  The basetype (int) is 
four bytes.


Ciao,
Michael.
