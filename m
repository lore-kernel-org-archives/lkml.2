Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1BNReQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:34:16 -0500
Received: from stinky.trash.net ([213.144.137.162]:57140 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1BNReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:34:12 -0500
Message-ID: <4D596792.40204@trash.net>
Date: Mon, 14 Feb 2011 18:34:10 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter is not a filesystem
References: <bug-28862-10286@https.bugzilla.kernel.org/> <20110210141119.56d789fc.akpm@linux-foundation.org>
In-Reply-To: <20110210141119.56d789fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.02.2011 23:11, schrieb Andrew Morton:
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

In this case this seems to be a simple bug, the seq_file callbacks
want to indicate that the current buffer is full, using an incorrect
code. I'm not sure why ENOSPC is used, this probably has never worked
(and strangely nobody seems to have noticed).

This bug is probably present in more parts of netfilter, I'll do an
audit and fix up all similar problems.
