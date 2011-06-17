Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab1FQOBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:01:00 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39020 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757622Ab1FQOA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:00:56 -0400
Date: Fri, 17 Jun 2011 14:51:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: f6bvp <f6bvp@free.fr>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Subject: Re: [AX25] inconsistent lock state
Message-ID: <20110617135147.GA3470@linux-mips.org>
References: <4B2CD772.1030106@upmc.fr>
 <20100115203654.GA3084@del.dom.local>
 <4DFA662D.5030302@free.fr>
 <201106171536.15660.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171536.15660.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:36:15PM +0200, Arnd Bergmann wrote:

(Removed Jarek from cc; his email bounces.)

> The message hints that disc_data_lock is aquired with softirqs disabled,
> but does not itself disable softirqs, which can in rare circumstances
> lead to a deadlock.
> 
> Does this fix it?

If so, drivers/net/hamradio.c, function sp_get() would probably need the
equivalent fix.  Same for drivers/net/ppp_async.c:ap_get() and sp_get() in
drivers/net/ppp_synctty.c.

  Ralf
