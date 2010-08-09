Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0HIVlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:41:39 -0400
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:34695 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0HIVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:41:38 -0400
Message-ID: <4C607608.8080305@genband.com>
Date: Mon, 09 Aug 2010 15:41:28 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rob Donovan <rob@proivrc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FCNTL Performance problem
References: <013501cb372f$912ce420$b386ac60$@proivrc.com>
In-Reply-To: <013501cb372f$912ce420$b386ac60$@proivrc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2010 21:41:30.0311 (UTC) FILETIME=[A0C2D570:01CB380B]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17560.002
X-TM-AS-Result: No--12.882600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2010 01:26 PM, Rob Donovan wrote:


> The problem is, when you have lots of F_RDLCK locks being created and
> released, then it slows down any F_WRLCK with F_SETLKW locks massively.

> Is there anything that can possibly be done in the kernel to help this, as I
> would have thought this could cause problems with other people?
> 
> One possible solution would be that when the write lock tries to get a lock
> and cant, its actually puts its lock in a queue of some kind, so that the
> other reads that are about to start can see that, and they 'queue' and wait
> for the write lock first.. I'm obviously not a kernel coder, so I have no
> idea of the effects of something like that, hence this post. 

What you're seeing is classical "reader priority" behaviour.  The
alternative is "writer priority".  I don't think POSIX specifies which
behaviour to use, so it's up to the various implementations.

If you really need writer priority, how about building your own lock
object in userspace on top of fcntl locks?

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
