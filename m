Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0FIRr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:47:58 -0400
Received: from THUNK.ORG ([69.25.196.29]:46614 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0FIRr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:47:56 -0400
Date: Wed, 9 Jun 2010 13:47:44 -0400
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609174744.GG6162@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
	akpm@inux-foundation.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
 <20100609094850.GA23292@elte.hu>
 <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
 <20100609155041.GD6162@thunk.org>
 <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
 <20100609171015.GE6162@thunk.org>
 <alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006091023341.4506@i5.linux-foundation.org>
 <20100609173424.GF6162@thunk.org>
 <alpine.LFD.2.00.1006091041540.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006091041540.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 10:43:33AM -0700, Linus Torvalds wrote:
> 
> We need that bitmap to handle the overflow max_pid case. We are _not_ 
> returning just increasing pid numbers.

Doh!  I knew I was forgetting something obvious.  I was hoping we
could get rid of the bitmap entirely, but I guess not....

(Unless users would stand for 64-bit pid numbers... no?  Dang. :-)

      	      	     	    	      - Ted
