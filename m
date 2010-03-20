Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0CTTYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:24:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab0CTTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:24:46 -0400
Date: Sat, 20 Mar 2010 12:20:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
In-Reply-To: <4B9136F4.4010007@gmail.com>
Message-ID: <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Jiri Slaby wrote:
> 
> please pull the writable limits tree below.

Ok, sorry for the long delay - I spent 5 days at two separate intel events 
over the last two weeks, which ended up sucking up a lot of my spare time 
that I normally use to try to judge the merge window stuff. As a result, I 
pulled mainly code that wasn't new (ie existing models), or that was 
"obviously independent" (liek the new ceph filesystem) and didn't have any 
contentious issues.

As a result, I ended up looking at the writable limits only today.

And I'm not entirely happy. For example, I absolutely _detest_ seeing new 
compat code for a feature that was just added. My immediate reaction is 
"WTF? What kind of moron doesn't make things 64-bit safe to begin with?". 
It's really annoying.

Why doesn't the new set/getprlimit things just take a pointer to a 
well-defined pair of 64-bit values? Why is there any compat cruft at all 
there? That is beyond insane. Just make the user level interface work 
right in the first place, instead of adding crazy compat crap. This is 
_not_ a legacy interface.

I'd also like to hear more about actual uses. Does _any_ other Unix-like 
system actually implement this writable limits thing? Who is asking for 
it? 

			Linus
