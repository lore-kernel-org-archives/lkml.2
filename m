Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0L3TCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:02:48 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:53557 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0L3TCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:02:47 -0500
Message-ID: <4D1CD751.4000509@vflare.org>
Date: Fri, 31 Dec 2010 00:32:41 +0530
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Dennis Jansen <dennis.jansen@web.de>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][zram] Do not check for init flag before starting I/O
References: <1293700078-5141-1-git-send-email-ngupta@vflare.org> <AANLkTi=R0sOvSZqu+Va=W2xJMKEw+kJXufuDwNe8o5NL@mail.gmail.com>
In-Reply-To: <AANLkTi=R0sOvSZqu+Va=W2xJMKEw+kJXufuDwNe8o5NL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 10:47 PM, Linus Torvalds wrote:
> On Thu, Dec 30, 2010 at 1:07 AM, Nitin Gupta<ngupta@vflare.org>  wrote:
>> zram module is unusable without this fix.
>
> .. and apparently it oopses without it.
>
> See commit 7e24cce38a99f3 which added the code that you now remove.
> You were cc'd on it, I don't think we got any reply to it.
>

This commit shows oops in zram_inc_stat() which does not exist in 
staging tree version of zram. Its actually a problem with zram version 
as present in project's own repository where we allocate struct 
zram_stats_cpu upon device initialization. OTOH, In mainline/staging 
version of zram, we allocate struct stats upfront, so this oops cannot 
happen in mainline version.

So, this commit is not even applicable for mainline/staging tree.  My 
bad, I didn't get a chance to review that patch.

> So no. I'm not taking this without way more explanations of why the
> original problem isn't a problem any more.
>

I will now end development on local project repository and sync it with 
the mainline version, so all future development happens on 
mainline/staging only, avoiding such confusions in future.


Nitin
