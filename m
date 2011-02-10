Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1BJWLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:11:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757161Ab1BJWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:11:20 -0500
Date: Thu, 10 Feb 2011 14:11:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: netfilter is not a filesystem
Message-Id: <20110210141119.56d789fc.akpm@linux-foundation.org>
In-Reply-To: <bug-28862-10286@https.bugzilla.kernel.org/>
References: <bug-28862-10286@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 21:55:26 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=28862
> 
>            Summary: /proc/net/ip_conntrack: no space left on device
>                     systematically

This is why I'm forever nagging people to not just grab some errno
because its name happens to sound similar to the error you just detected.

Yes, it superficially seems nice and logical for netfilter to use
ENOSPC when it runs out of space.  But when that error code propagates
up to the user, they see "no space left on device" and will then run
"df" and wonder what the hell happened to their computer.

The kernel makes this mistake a *lot*.  EFBIG in the rtc drivers?  Really?
