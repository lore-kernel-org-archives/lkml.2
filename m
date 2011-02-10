Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1BJWVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:21:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58408
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757161Ab1BJWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:21:30 -0500
Date: Thu, 10 Feb 2011 14:22:06 -0800 (PST)
Message-Id: <20110210.142206.183039613.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter is not a filesystem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110210141119.56d789fc.akpm@linux-foundation.org>
References: <bug-28862-10286@https.bugzilla.kernel.org/>
	<20110210141119.56d789fc.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Feb 2011 14:11:19 -0800

> On Thu, 10 Feb 2011 21:55:26 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=28862
>> 
>>            Summary: /proc/net/ip_conntrack: no space left on device
>>                     systematically
> 
> This is why I'm forever nagging people to not just grab some errno
> because its name happens to sound similar to the error you just detected.
> 
> Yes, it superficially seems nice and logical for netfilter to use
> ENOSPC when it runs out of space.  But when that error code propagates
> up to the user, they see "no space left on device" and will then run
> "df" and wonder what the hell happened to their computer.
> 
> The kernel makes this mistake a *lot*.  EFBIG in the rtc drivers?  Really?

We are in this conundrum because the granularity of errors which can
be indicated by errno signalling is very low.

And one way people handle this is to use all sorts of different types
of errno values to indicate the different cases.

Also, one can argue that it is erroneous for userspace to assume that
error codes are not context dependent.  They most certainly are.
