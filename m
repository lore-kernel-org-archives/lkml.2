Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab0EYS0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:26:39 -0400
Received: from smtp141.mail.ukl.yahoo.com ([77.238.184.72]:32907 "HELO
	smtp141.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932566Ab0EYS0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:26:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=tJM1ewCswgfh0H066GHL+OvQrHk8HkaY/1qUuBbYWhjxkiCLEARhNQV/oIAu4Ym5hvMnPOyv+nwePlzTjx6ACN5UFrlbiOmgc/6k/PWWdTpI6M+rwmWm68DlGWqOZ7jaz4k3pMRd8K5OnoHkqQ5bUmMt2TjZ+k5+GBTGM6wEtZw=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: n_hGC0sVM1nEnkeQxRgDC7SXDchJmwAFSwWUjCYVqsCQe_IHmRCY5_LuSIsDJczoNNOQIVy69YHERjdiHyhS9rxhz2mFWQj0w.4O6_ZsfSbzPpN4YLPFTI1irX375CpeRh0MLWy.06RJpsLsnGfbJvMe7bsFy1mMrte5kkQZ_UMG8o2VujYHDRD2QwQXeA5ZXYrmwEB9AlQ1NAP8I5Jrid5aT3jh.redtdbiDwCBjfOrA80nB3DLv8EvghWdlAhDRmkUCSYAHOVRU57TGlI_V5.frvgGnMas
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BFC1657.5000707@yahoo.es>
Date: Tue, 25 May 2010 20:26:31 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: aya Kumar <jayakumar.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Subject: Re: page_mkwrite vs pte dirty race in fb_defio
References: <20100525160149.GE20853@laptop>
In-Reply-To: <20100525160149.GE20853@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/25/2010 06:01 PM, Nick Piggin wrote:
> Hi,
> 
> I couldn't find where this patch (49bbd815fd8) was discussed, so I'll
> make my own thread. Adding a few lists to cc because it might be of
> interest to driver and filesystem writers.
> 

The original thread can be found here:
http://marc.info/?l=linux-fbdev&m=127369791432181

> The old ->page_mkwrite calling convention was causing problems exactly
> because of this race, and we solved it by allowing page_mkwrite to
> return with the page locked, and the lock will be held until the
> pte is marked dirty. See commit b827e496c893de0c0f142abfaeb8730a2fd6b37f.
> 

Ah, didn't know about that. Thanks for the pointer.

> I hope that should provide a more elegant solution to your problem. I
> would really like you to take a look at that, because we already have
> filesystem code (NFS) relying on it, and more code we have relying on
> this synchronization, the more chance we would find a subtle problem
> with it (also it should be just nicer).
> 

So if I undestand it correctly, using the "new" calling convention I should just lock the page on fb_deferred_io_mkwrite() and return VM_FAULT_LOCKED to fix the described race for fb_defio.

> Thanks,
> Nick
> 

Thanks,
Albert
