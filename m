Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1FNQ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:58:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34998 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1FNQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=Bd4F8fMJtlFiVlVaI3vQOyNXvTmm7KRL6rIa3iYVLgXUcMGo47xONXQ2ms8vEdJ5cB
         uqRPl6Eh6usjF4jAaXpxtRSciuLEKEOg1vlt0xAT5iIWLBSwT9xb4hmv5hKNz8uy23Ie
         7dwTI+E664emuNLwxhJvwLHemJlg/s88bILow=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>
Subject: Re: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106141549.29315.arnd@arndb.de> <op.vw2jmhir3l0zgt@mnazarewicz-glaptop>
 <201106141803.00876.arnd@arndb.de>
Date: Tue, 14 Jun 2011 18:58:35 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vw2r3xrj3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106141803.00876.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 14 Jun 2011 15:49:29 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
>>> Please explain the exact requirements that lead you to defining  
>>> multiple contexts.

> On Tuesday 14 June 2011, Michal Nazarewicz wrote:
>> Some devices may have access only to some banks of memory.  Some devices
>> may use different banks of memory for different purposes.

On Tue, 14 Jun 2011 18:03:00 +0200, Arnd Bergmann wrote:
> For all I know, that is something that is only true for a few very  
> special Samsung devices,

Maybe.  I'm just answering your question. :)

Ah yes, I forgot that separate regions for different purposes could
decrease fragmentation.

> I would suggest going forward without having multiple regions:

Is having support for multiple regions a bad thing?  Frankly,
removing this support will change code from reading context passed
as argument to code reading context from global variable.  Nothing
is gained; functionality is lost.

> * Remove the registration of specific addresses from the initial patch
>   set (but keep the patch).
> * Add a heuristic plus command-line override to automatically come up
>   with a reasonable location+size for *one* CMA area in the system.

I'm not arguing those.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
