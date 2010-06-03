Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FCX0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:26:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab0FCX0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:26:40 -0400
Date: Thu, 3 Jun 2010 16:21:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603161513.60370e98@nehalam>
Message-ID: <alpine.LFD.2.00.1006031618510.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam> <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org> <20100603120313.10a73b20@nehalam> <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
 <20100603144913.24828629@nehalam> <alpine.LFD.2.00.1006031455280.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006031515030.8175@i5.linux-foundation.org> <20100603161513.60370e98@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> 
> Maybe putting all back together in a threaded_irq would be safest.

Yes. That floppy driver could easily be a good case for using those 
threaded irq's. The problem, of course, is to find somebody motivated 
enough. The code-base really is pretty dang ugly, and it might be hard to 
do it incrementally, I think.

(And starting from scratch is likely not a great idea either - while 
_some_ of the ugliness comes from the odd irq-driven state machine code, a 
lot of it also comes from trying to handle all those floppy formats etc)

			Linus
