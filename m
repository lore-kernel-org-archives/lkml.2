Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0EQUN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:13:59 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35599 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0EQUN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:13:58 -0400
Date: Mon, 17 May 2010 21:13:39 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
       willy@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
Message-ID: <20100517201339.GJ20356@shareable.org>
References: <20100517043353.GA22127@kryten> <20100517043457.GA22416@kryten> <alpine.LFD.2.00.1005170800100.4195@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005170800100.4195@i5.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> 
> On Mon, 17 May 2010, Anton Blanchard wrote:
> > 
> > It turns out this bad code is a result of us defining atomic_t as a
> > volatile int.
> 
> Heh. Ok, as you point out in the commit message, I obviously agree with 
> this patch. "volatile" on data is evil, with the possible exception of 
> "jiffies" type things.

I wonder if

   extern unsigned long __nv_jiffies;
   #define jiffies (*(volatile unsigned long *)*__nv_jiffies)

would improve any code in the same way as this atomic_t change.

-- Jamie
