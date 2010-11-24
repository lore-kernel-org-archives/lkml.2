Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0KXW4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:56:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:12332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab0KXW4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:56:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,250,1288594800"; 
   d="scan'208";a="680809469"
Date: Wed, 24 Nov 2010 22:36:00 +0000
From: Alan Cox <alan@linux.intel.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101124223600.5eb8476f@bob.linux.org.uk>
In-Reply-To: <20101125013812.0dc828ad@tornado.gnet>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101124164329.75368d71@lxorguk.ukuu.org.uk>
	<20101125013812.0dc828ad@tornado.gnet>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, indeed, it's a bug. Please consider the following example:
> 
>      CPU1                                      CPU2
> =========================================================
> uart_handle_dcd_change() {		tty_set_ldisc() {
>   ld = tty_ldisc_ref(...)			  ...

[We have a reference]
>   ...					  tty_ldisc_halt(...)
					  [Should block]

> I think tty code is exactly the right place to fix this bug; this is
> what my patch is for.

More special case magic on top of the current crap isn't the right fix
here, tty_ldisc_halt needs to wait for the references to hit zero.

Alan
 

