Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2BBJiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:38:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab2BBJiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:38:00 -0500
Date: Thu, 2 Feb 2012 10:37:59 +0100 (CET)
From: Richard Guenther <rguenther@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Colin Walters <walters@verbum.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
In-Reply-To: <CA+55aFxt3rG8_HyoRqiMOKVDqaGTkRk=Kh+bAJTAxxdHAGzuVw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202021037180.4999@zhemvz.fhfr.qr>
References: <20120201151918.GC16714@quack.suse.cz> <1328114266.5355.44.camel@lenny> <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com> <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz> <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
 <CA+55aFxt3rG8_HyoRqiMOKVDqaGTkRk=Kh+bAJTAxxdHAGzuVw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Linus Torvalds wrote:

> Just out of morbid curiosity, what happens if you have totally
> *separate* variables that just happen to link together? IOW, something
> like
> 
>    static struct { unsigned bit:1; } onebit;
>    static volatile int var;
> 
> and they just *happen* to link next to each other (because they were
> declared next to each other) in the same 8-byte aligned block?

Just to make you run away screaming ...

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48124

where exactly such situation happens ...

Richard.
