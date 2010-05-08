Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab0EHG5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 02:57:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49787 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EHG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 02:57:53 -0400
Message-ID: <4BE50AA3.6040806@vflare.org>
Date: Sat, 08 May 2010 12:24:27 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 (v2)
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <20100507155504.10532b3e.akpm@linux-foundation.org> <4BE504AD.4030807@cs.helsinki.fi>
In-Reply-To: <4BE504AD.4030807@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/08/2010 11:59 AM, Pekka Enberg wrote:
> 
> Andrew Morton wrote:
>> The driver appears to be controlled by some nasty-looking ioctl against
>> some fd.  None of it is documented anywhere.  It should be.  You're
>> proposing here a permanent extension to the kernel ABI which we will
>> need to maintain for ever.  That's a big deal and it is the very first
>> thing reviewers will look at, before even considering the code.
> 
> I thought we got rid of it? Nitin?
>

No, we didn't get rid of any ioctls. In fact, issuing ioctls is how we
configure various ramzswap devices (using rzscontrol utility). The
functionality of all these ioctls is well documented in rzscontrol
manpage. Now, I will also add relevant comments in the code.

 
>> RZSIO_GET_STATS looks to be hopeless from a long-term maintainability
>> POV.  It's debug code and it would be better to move it into a debugfs
>> file, where we can then add and remove things at will.
> 
> Yup.
> 

Its not debug code. This ioctl is how we send stats about given ramzswap
device to userspace: rzscontrol /dev/ramzswap --stats, invokes this ioctl
and prints the stats. I will add comments to this part to make it clear.


Thanks,
Nitin
