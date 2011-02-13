Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1BMUhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:37:20 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11544 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744Ab1BMUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:37:16 -0500
X-IronPort-AV: E=Sophos;i="4.60,465,1291590000"; 
   d="scan'208";a="91224882"
Message-ID: <4D5840F6.8030401@ens-lyon.org>
Date: Sun, 13 Feb 2011 21:37:10 +0100
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Nikolaus Rath <Nikolaus@rath.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: virt_to_page for userspace pointers
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu> <878vxuxkfr.fsf@inspiron.ap.columbia.edu> <4D4DC2D6.8030905@ens-lyon.org> <4D583E17.80606@rath.org>
In-Reply-To: <4D583E17.80606@rath.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/02/2011 21:24, Nikolaus Rath a écrit :
> On 02/05/2011 04:36 PM, Brice Goglin wrote:
>   
>>> Is there an equivalent function to virt_to_page (and virt_to_phys) that
>>> works with userspace pointers? Or do I have to manually walk through the
>>> page tables? In the later case, are there any examples of this kind of
>>> search that I could use as a basis?
>>>   
>>>       
>> You probably want get_user_pages() (or get_user_pages_fast()).
>>     
> Thanks for the pointer, that already helped a lot!
>
> I would, however, prefer a more primitive function that just gives me
> the struct page without locking it. And if the page is swapped out, I'd
> rather get a NULL pointer than having a page frame allocated.  Is there
> anything like that?
>   

If you don't lock the page, you have no guarantee that it won't get
swapped out or migrated while you look at the physical page.

Brice

