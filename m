Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0CUBqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:46:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42189 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0CUBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:46:04 -0400
Date: Sat, 20 Mar 2010 21:45:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
Message-ID: <20100321014554.GA2079@localhost.localdomain>
References: <4B1D32D1.4090404@gmail.com>
 <4B9136F4.4010007@gmail.com>
 <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:20:58PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Mar 2010, Jiri Slaby wrote:
> > 
> > please pull the writable limits tree below.
> 
> Ok, sorry for the long delay - I spent 5 days at two separate intel events 
> over the last two weeks, which ended up sucking up a lot of my spare time 
> that I normally use to try to judge the merge window stuff. As a result, I 
> pulled mainly code that wasn't new (ie existing models), or that was 
> "obviously independent" (liek the new ceph filesystem) and didn't have any 
> contentious issues.
> 
> As a result, I ended up looking at the writable limits only today.
> 
> And I'm not entirely happy. For example, I absolutely _detest_ seeing new 
> compat code for a feature that was just added. My immediate reaction is 
> "WTF? What kind of moron doesn't make things 64-bit safe to begin with?". 
> It's really annoying.
> 
> Why doesn't the new set/getprlimit things just take a pointer to a 
> well-defined pair of 64-bit values? Why is there any compat cruft at all 
> there? That is beyond insane. Just make the user level interface work 
> right in the first place, instead of adding crazy compat crap. This is 
> _not_ a legacy interface.
> 
I won't speak to this yet, its been awhile since I looked at it, but I don't
recall there being any compat code in place (although it went through several
revisions, so I may be thinking of the wrong version).

> I'd also like to hear more about actual uses. Does _any_ other Unix-like 
> system actually implement this writable limits thing? Who is asking for 
> it? 
> 
The main request that I've gotten in regards to this feature request is for
admins who want to make limits adjustments to processes without the need to
restart them.  The specific example I've been given is the desire to increase
the number of open files a database process can hold without needing to restart
the database.

Neil

> 			Linus
> 
