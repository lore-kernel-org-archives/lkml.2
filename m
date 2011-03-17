Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1CQVdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1CQVdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:33:02 -0400
Date: Thu, 17 Mar 2011 17:32:52 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-ID: <20110317213252.GB4084@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110317045209.GA18656@redhat.com>
 <20110317193645.GD14675@home.goodmis.org>
 <20110317200215.GA4084@redhat.com>
 <1300394224.16880.518.camel@gandalf.stny.rr.com>
 <20110317141108.52697d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317141108.52697d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 02:11:08PM -0700, Andrew Morton wrote:
 
 > Dave's patch is tested (I assume), so it wins ;)

indeed, it's the one I've been using for.. ages.

 > Maybe it's just me, but I think it would be better to use bzero() for
 > this operation - it's more readable and it can't be screwed up.  Then
 > checkpatch checks for memset(xxx, 0, xxx) and for memset(xxx, xxx, 0)
 > and says "hey, use bzero".  

god yes.  I don't know why it fell out of favor in userspace[*], but we
don't have to follow suit in the kernel.  I thought we actually had
a generic bzero, but it seems not from a quick grep.  I'll hack something up.

it only needs to be a #define bzero(x,y)	memset (x, 0, y);

where should it live, linux/kernel.h ?

	Dave


[*]  man bzero shows.. "This function is deprecated", which is possibly one
     of the dumbest moves ever, given how commonplace this bug is.
