Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1FTRDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:03:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46437 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1FTRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:03:07 -0400
Date: Mon, 20 Jun 2011 18:03:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] get_write_access()/deny_write_access() without
 inode->i_lock
Message-ID: <20110620170305.GW11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
 <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
 <20110620161352.GT11521@ZenIV.linux.org.uk>
 <BANLkTikUi9M1Mx4L54vJOP0SK0P3yAz=uQ@mail.gmail.com>
 <20110620164211.GV11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620164211.GV11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:42:11PM +0100, Al Viro wrote:

> BTW, atomic_add_unless/atomic_inc_not_zero is done as read/cmpxchg on
> everything I've checked, including alpha and sparc.  I suspect that
> it's seriously suboptimal there...

Actually, on sparc it's probably fine.  alpha, OTOH, probably ought to switch
to something similar to what ppc is doing...
