Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0FIQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:48:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757885Ab0FIQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:48:20 -0400
Date: Wed, 9 Jun 2010 09:48:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Implement the GDB remote protocol 'p' command to
 retrieve a register
In-Reply-To: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org>
References: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, David Howells wrote:
>
> Implement the GDB remote protocol 'p' command to retrieve a single register
> value.

Is there any value to this? Apparently it used to work just because that 
command never did anything (rather than return an error). Why not just 
reinstate that behavior instead?

There's doesn't seem to be any reason to implement the single-register 
case unless there is some legacy use of it. There's a good reason gdb 
tends to use the "register block" thing, and it tends to be easier to 
implement too (no crazy case statements etc).

			Linus
