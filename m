Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab1CXSoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:44:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47394 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CXSoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:44:20 -0400
Date: Thu, 24 Mar 2011 18:44:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Reichelt <debian@nachtgeist.net>, linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for
 /proc/<pid> dirs
Message-ID: <20110324184417.GE22723@ZenIV.linux.org.uk>
References: <4D8AC408.9000503@nachtgeist.net>
 <20110324073225.GA3806@p183.telecom.by>
 <4D8B03D6.2090204@nachtgeist.net>
 <20110324182230.GB5187@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324182230.GB5187@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:22:30PM +0200, Alexey Dobriyan wrote:
> On Thu, Mar 24, 2011 at 09:41:58AM +0100, Daniel Reichelt wrote:
> > > Keeping u/g/o inside kernel is horrible.
> > 
> > Why exactly? Since it's only a char and not char[] I don't see the
> > disadvantage over int or a define or whatever. Of course I could always
> > change that if that's a de-facto standard I just didn't know about.
> 
> Keep mode_t inside kernel, this will get rid of many ifdefs.
>  
> > > What is the usecase? Content of /proc/* is identical.
> > 
> > Use-case is to isolate process information from other users' or groups'
> > eyes, e.g. with 550 the output of ps aux only lists processes of the
> > groups your user is a member of.
> 
> This is doable with some ps(1) switch, I'm sure.
> 
> The content of /proc/$PID directory is not a secret.

More to the point, permissions in /proc/<pid>/* don't do us much good.
As the matter of fact, we ought to make them all flat - i.e. same for
user/group/other, since we have to recheck access rights on every damn
IO operations.  Checks done at open() are useless here - have the
task exec suid-root binary and they are obsolete.
