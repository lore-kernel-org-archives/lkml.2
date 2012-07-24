Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2GXVsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:48:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:24583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab2GXVsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:48:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="197575812"
Date: Tue, 24 Jul 2012 23:05:27 +0100
From: Alan Cox <alan@linux.intel.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Oops after merge of tty-next
Message-ID: <20120724230527.2135198e@bob.linux.org.uk>
In-Reply-To: <500D64D7.3060902@mev.co.uk>
References: <5009D68A.3050301@mev.co.uk>
	<20120721234145.354e6ee9@pyramind.ukuu.org.uk>
	<500D64D7.3060902@mev.co.uk>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012 15:51:03 +0100
Ian Abbott <abbotti@mev.co.uk> wrote:

> On 2012-07-21 23:41, Alan Cox wrote:
> > On Fri, 20 Jul 2012 23:07:06 +0100
> > Ian Abbott <abbotti@mev.co.uk> wrote:
> >
> >> I'm getting an Oops in the linux-next tree today after the merge
> >> of the remote-tracking branch 'tty/tty-next'.  I bisected it down
> >> to commit 36b3c070d2346c890d690d71f6eab02f8c511137 in
> >> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git :

Ok Greg you can you leave that one in -next but not push it for 3.6.

I need to go over this in some detail and figure out the remaining
race, and worse yet how to fix it without the mess of existing locks
turning it into something nasty.

I think I understand what is needed but I don't want to be doing it as
a mad panic for 3.6. On the bright side I think it explains the other
tty lock splitting mysteries.

Alan
