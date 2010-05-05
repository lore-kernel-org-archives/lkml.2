Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab0EEPQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:16:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab0EEPQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:16:13 -0400
Date: Wed, 5 May 2010 08:14:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
cc: Greg KH <greg@kroah.com>, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed
 memory
In-Reply-To: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Nitin Gupta wrote:
> 
> ramzswap driver creates RAM based block devices which can be
> used (only) as swap disks. Pages swapped to these disks are
> compressed and stored in memory itself.

Ok, this patch series looks way better, if only because it looks less 
hacky.

That said, I absolutely _hate_ the f*cking notifier model that takes 
"type" flags. It's a disgrace. It's a horrible horrible model.

I'd much rather bind a nice "swap_operations" structure to the device, and 
have that structure have function pointers for the different operations. 
No stupid "operation type codes". Real, honest-to-goodness function 
pointers.

The notifier layer is a total piece of sh*t. I'm sorry I ever merged it, 
and I'm _doubly_ sorry that it's use is so horribly widespread. It's a 
mistake.

		Linus
