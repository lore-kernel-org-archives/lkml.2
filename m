Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0EYWNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:13:50 -0400
Received: from smtp146.mail.ukl.yahoo.com ([77.238.184.77]:38906 "HELO
	smtp146.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752611Ab0EYWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:13:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=b5IHv9hdLmO4qjoy5NrnX5XfKqt2uJOAByihwCLKLjTpOJSZTeLE7Py329R/aodRFiTZ/WCs9WExqvDMBug3Af4+yonf/Qa9WTx88g6uuoI9YwVlYAxSqn069I7sQHVTvyGH3I/deR7YOOk9LQ7JgppckH8TGFKTeZYmfJtp+qY=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: _wqKn0YVM1kwM5pZcgp.KXwZH0UZPfk8UB8X1y_73tDVPbUTo8x8BshPY0ynu_DY9rNxafzFKwcdTdi04YTjrsIDfDDTSFReqDrWLwcWJYwwUFvI8wRV4q1I7nD2MCOhTcOV6KLEE0o9BhsAZRT4PHaiUScisUpkuLfol36lhz_5UgB17.SexGdbr9Vms3gRxudL98NdB4hjRwX2TFcn9Xri4x1ZkxCVb4oFFBd3ZmfJrR4pMt9cdrevhNXAav83
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BFC4B9D.1080902@yahoo.es>
Date: Wed, 26 May 2010 00:13:49 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: aya Kumar <jayakumar.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Subject: Re: [Bulk] Re: page_mkwrite vs pte dirty race in fb_defio
References: <20100525160149.GE20853@laptop> <4BFC1657.5000707@yahoo.es> <20100525184700.GJ20853@laptop>
In-Reply-To: <20100525184700.GJ20853@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2010 08:47 PM, Nick Piggin wrote:
>>> I hope that should provide a more elegant solution to your problem. I
>>> would really like you to take a look at that, because we already have
>>> filesystem code (NFS) relying on it, and more code we have relying on
>>> this synchronization, the more chance we would find a subtle problem
>>> with it (also it should be just nicer).
>>
>> So if I undestand it correctly, using the "new" calling convention I should just lock the page on fb_deferred_io_mkwrite() and return VM_FAULT_LOCKED to fix the described race for fb_defio.
> 
> As far as I can see from quick reading of the fb_defio code, yes
> that should solve it (provided you lock the page inside the mutex,
> of course).
> 

Ok, thanks. I'm posting a new version as RFT.

Cheers,
Albert

