Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab0GBRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:52:18 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:13956 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab0GBRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:52:16 -0400
Message-ID: <4C2E274F.2040909@tilera.com>
Date: Fri, 2 Jul 2010 13:52:15 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic
 network.
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006282134.55166.arnd@arndb.de> <4C2DD958.7030005@tilera.com> <201007021811.04197.arnd@arndb.de>
In-Reply-To: <201007021811.04197.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2010 12:11 PM, Arnd Bergmann wrote:
> On Friday 02 July 2010, Chris Metcalf wrote:
>   
>> So, if there's a good reason for it to be there, I'd say that pushes us
>> back toward a separate <linux/list_types.h>.  Otherwise we can
>> investigate splitting out the prefetch content on every platform to
>> <asm/prefetch.h> (presumably creating some empty <asm/prefetch.h>
>> headers on architectures that just use the gcc builtin) and adding new
>> #includes of <asm/prefetch.h> to files that reference the prefetch
>> functionality.  Arnd and other list folks, what's your instinct?
>>     
> Makes sense. Splitting out the list types from list.h does seem to be
> safest option. We might actually be able to do some header file
> untangling that way, by using list_types.h in all headers that
> use a list_head by none of the macros and functions associated with it.
>   

For now I'll just stick with the straight splitting-out (see recent git
email).  There may be kernel code that is getting the list macros and
functions "by accident" by including some header that in itself only
needs the structs and so could use <linux/list_types.h>, and would need
to #include <linux/list.h> itself to avoid breaking.  There would
probably be a long tail of complaints that developers' obscure
architecture, driver, etc., had been broken by an aggressive
"untangling" change.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

