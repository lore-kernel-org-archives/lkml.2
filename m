Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab1CXSuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:50:12 -0400
Received: from srv04.jarevo.de ([88.198.54.146]:65436 "EHLO srv04.jarevo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab1CXSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:50:09 -0400
Message-ID: <4D8B9253.7030107@nachtgeist.net>
Date: Thu, 24 Mar 2011 19:49:55 +0100
From: Daniel Reichelt <debian@nachtgeist.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for /proc/<pid>
 dirs
References: <4D8AC408.9000503@nachtgeist.net> <20110324073225.GA3806@p183.telecom.by> <4D8B03D6.2090204@nachtgeist.net> <20110324182230.GB5187@p183.telecom.by>
In-Reply-To: <20110324182230.GB5187@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why exactly? Since it's only a char and not char[] I don't see the
>> disadvantage over int or a define or whatever. Of course I could always
>> change that if that's a de-facto standard I just didn't know about.
> 
> Keep mode_t inside kernel, this will get rid of many ifdefs.

Too obvious, point made.


>> Use-case is to isolate process information from other users' or groups'
>> eyes, e.g. with 550 the output of ps aux only lists processes of the
>> groups your user is a member of.
> 
> This is doable with some ps(1) switch, I'm sure.
> 
> The content of /proc/$PID directory is not a secret.

Sure, I could just run ps ux instead of ps aux and I'm done - in case I
wanna see only MY procs. That's my very point: sometimes it needs to be
a secret and not by ps-invoking-user's choice at that but by an admin's
enforcement. There are cases where I wouldn't want anybody ELSE to know
ANYTHING about my procs, not even their existence. So even when I'm root
on a box and I could restrict user-space tools...there's always another
unrestricted one. A curious user just compiles his own toy and goes fishing.

Real-world example: amongst many other (administrative) isolation
mechanisms to keep users apart, I've been using this approach for years
to enforce privacy in several hosting environments. Just think of poorly
implemented software which doesn't mask cmdline parameters like
--password. Of course one could argue "Just switch to another software."
Needless to say, that's often not option.
