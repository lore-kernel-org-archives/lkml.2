Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab0EMQSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:18:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683Ab0EMQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:18:42 -0400
Date: Thu, 13 May 2010 09:16:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Bastien Nocera <hadess@hadess.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <20100513155031.GA22238@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1005130908350.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <1273762051.2308.4671.camel@localhost.localdomain> <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
 <20100513155031.GA22238@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Dmitry Torokhov wrote:
> 
> From what I remember (it was a few weeks old thread) we were hanging
> when trying to read from the controller in i8042_flush(). Normally, if
> controller isn't there we'd get a stream of 0xff which will never
> "clear" and so after 32 reads we give up and abort controller
> initialization. But on Bastien's box it just sits there.

Is there a web interface to some archive for linux-input (or was this 
thread on lkml)?

Anyway, the fact that apparently pressing the power button makes it come 
alive again implies that it's likely SCI/SMI-related. Which is not 
entirely unexpected if there is some crazy SMM thing going on. But 
presumably whatever buggy Apple code is _supposed_ to work for Windows, so 
I wonder what bug that quite simple status/data register read could 
possibly trigger.

Is it the status read or the data read that causes problems, and is it the 
first one or after doing a few? A couple of printk's in that i8042_flush() 
routine should tell us.

			Linus
