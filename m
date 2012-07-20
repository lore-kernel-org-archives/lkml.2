Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2GTJsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:48:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2GTJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:47:55 -0400
Date: Fri, 20 Jul 2012 11:47:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org, wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for July 17 (debugobjects: bt | btusb | usb
 related?)
Message-ID: <20120720094748.GA16598@redhat.com>
References: <CA+icZUWXire09owq2Q9bN=C+VKuzSG+48Cz3-Ex+ZaTtGrEmQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWXire09owq2Q9bN=C+VKuzSG+48Cz3-Ex+ZaTtGrEmQA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 08:06:17PM +0200, Sedat Dilek wrote:
> On Tue, Jul 17, 2012 at 7:41 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Changes since 20120716:
> >
> 
> Not sure what the root cause of this issue is.
> 
> I see the following call-trace in linux-next (next-20120717).
> 
> [   23.431889] ------------[ cut here ]------------
> [   23.431896] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
> [   23.431897] Hardware name: <HIDDEN>
> [   23.431901] ODEBUG: free active (active state 0) object type:
> timer_list hint: delayed_work_timer_fn+0x0/0x40
There are few delayed works on hci_dev structure, it's hard to say which
one is not stopped before kfree.

> # CONFIG_DEBUG_OBJECTS_WORK is not set
If you enable that option, it should show which delayed work is causing trouble.

Stanislaw
