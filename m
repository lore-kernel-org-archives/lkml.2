Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1EZK4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:56:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55525 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1EZK4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:56:50 -0400
Date: Thu, 26 May 2011 11:56:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Daniel Reichelt <debian@nachtgeist.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: procfs: boot- and runtime configurable access mode for
 /proc/<pid> dirs
Message-ID: <20110526105647.GD11521@ZenIV.linux.org.uk>
References: <4D8AC408.9000503@nachtgeist.net>
 <20110324073225.GA3806@p183.telecom.by>
 <4D8B03D6.2090204@nachtgeist.net>
 <20110324182230.GB5187@p183.telecom.by>
 <4D8B991E.5070604@nachtgeist.net>
 <20110324203758.GF22723@ZenIV.linux.org.uk>
 <alpine.DEB.2.01.1103251418300.4945@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1103251418300.4945@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 02:24:48PM -0700, Christian Kujau wrote:
> 
> Not sure If I understand correctly, but:
> 
> On Thu, 24 Mar 2011 at 20:37, Al Viro wrote:
> > Bull.  /proc/<pid>/foo contents is sensitive, your patch doesn't do
> > you any good.  fork(), open /proc/<child's PID>/foo in parent, then
> > exec suid-root binary in child.
> 
> ...you would have to roll your own suid-root binary to be able to look 
> into other /proc/PID directories, no? But making a binary suid-root 
> requires root to begin with.

No.  You could look into /proc/PID/foo of process running a suid-root binary
that you have execve()'ed.  A binary that had been there legitimately.  If
these files have sensitive contents, you have a bad problem on hands (and we
had quite a few of those); IOW, you need to do checks at read(2) time, since
the identity of owner can change between open() and read().  And if you do
those checks there, you don't need to care about open-time checks at all,
since any attempt to do IO will be rejected anyway.
