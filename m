Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab2CHTtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:49:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:56236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab2CHTtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:49:08 -0500
Message-ID: <1331236139.11248.407.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 20:48:59 +0100
In-Reply-To: <1331232159.25686.456.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 13:42 -0500, Steven Rostedt wrote:
> cpu_chill_on_lock().

I think what you were hinting at is:

  spin_lock(&lock);
  spin_unlock(&lock);

which is the rt_mutex implementation of spin_unlock_wait(). No new
function needed for that.

Trouble is that you cannot use inode->i_lock as explained..
