Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1F1WAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:00:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1F1WAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:00:13 -0400
Date: Wed, 29 Jun 2011 00:00:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on debugging use-after-free memory issues.
In-Reply-To: <4E08C80B.9070602@candelatech.com>
Message-ID: <alpine.LRH.2.00.1106282358450.14213@twin.jikos.cz>
References: <4E08C80B.9070602@candelatech.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Ben Greear wrote:

> I have a case where deleted memory is being passed into an RPC callback.  
> I enabled SLUB memory poisoning and verified that the data pointed to 
> has 0x6b...6b value.
> 
> Unfortunately, the rpc code is a giant maze of callbacks and I'm having 
> a difficult time figuring out where this data could be erroneously 
> deleted at.
> 
> So first question:
> 
> Given a pointer to memory, and with SLUB memory debuging on (and/or 
> other debugging options if applicable), is there a way to get any info 
> about where the memory was last deleted?
> 
> Second:  Any other suggestions for how to go about debugging this?
> 
> I hit this problem under load after multiple hours, so just adding 
> printks in random places may not be feasible...

First, this is not really a proper list for such questions. I'd propose 
kernel newbies community next time.

Anyway, I'd propose to start with kmemcheck (see 
Documentation/kmemcheck.txt). It could pin-point the problemtic spot 
immediately (or it might not).

-- 
Jiri Kosina
SUSE Labs

