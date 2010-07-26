Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0GZWra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:47:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46899 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab0GZWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vXTxS2SX8s2tcs5ysQuXm8ZVY6F9kIITZngVnyNzgFbgZGHtKOCBwxdaQ6KPW+g/32
         mxeX+zM1DvakUpZDmNbqj8SLniIsdrA3Wd+58YrO5q5V2ukt/024Y5J1lL2AzB2banAy
         SDxvVAh7bzuImsiXmkzEL6cYB6QBJ8Yy35Io0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007261136160.5438@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1007261136160.5438@router.home>
Date: Tue, 27 Jul 2010 07:47:26 +0900
Message-ID: <AANLkTikMMMWcT5Uvv5+80yeGP-uYbW7awQsHL7A7NXmw@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, Jul 27, 2010 at 1:40 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 27 Jul 2010, Minchan Kim wrote:
>
>> This patch registers address of mem_section to memmap itself's page struct's
>> pg->private field. This means the page is used for memmap of the section.
>> Otherwise, the page is used for other purpose and memmap has a hole.
>
> What if page->private just happens to be the value of the page struct?
> Even if that is not possible today, someday someone may add new
> functionality to the kernel where page->pivage == page is used for some
> reason.

I agree.

>
> Checking for PG_reserved wont work?

Okay. It would be better to consider page point itself with PG_reserved.
I will reflect your opinion next version. :)

Thanks, Christoph.




-- 
Kind regards,
Minchan Kim
