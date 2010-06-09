Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0FIFcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:32:25 -0400
Received: from mail.vyatta.com ([76.74.103.46]:58484 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0FIFcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:32:16 -0400
Date: Tue, 8 Jun 2010 22:32:11 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100608223211.0c0bb1bc@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006031618510.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam>
	<alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
	<20100603120313.10a73b20@nehalam>
	<alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
	<20100603144913.24828629@nehalam>
	<alpine.LFD.2.00.1006031455280.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031515030.8175@i5.linux-foundation.org>
	<20100603161513.60370e98@nehalam>
	<alpine.LFD.2.00.1006031618510.8175@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 16:21:55 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> > 
> > Maybe putting all back together in a threaded_irq would be safest.
> 
> Yes. That floppy driver could easily be a good case for using those 
> threaded irq's. The problem, of course, is to find somebody motivated 
> enough. The code-base really is pretty dang ugly, and it might be hard to 
> do it incrementally, I think.
> 
> (And starting from scratch is likely not a great idea either - while 
> _some_ of the ugliness comes from the odd irq-driven state machine code, a 
> lot of it also comes from trying to handle all those floppy formats etc)
> 
> 			Linus

I have fixes to stop the panic, but will hold off until 2.6.36.
For now want to make sure that there is no chance of causing worse problems
on real hardware.  There is no
reason there should ever be I/O error's and panic when running on virtual
hardware.
