Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0HXBUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:20:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53459 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0HXBT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DWsbDNaAjEtU5uZE3n+CWCAieOdTDFpsOuG1tXTJuihyckuk5NYZNEdGbasQyxb1Pa
         eZ7nIb//H+Z50eZPBrfmAAB6RGEjMV5epiHMK0MOm2WDFRGdoCDct5YQhPPIjWdLoMGf
         Koo+lXtPVQS7aGjRbUtkCSYAvJqULPXunLJCY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008231217100.9840@router.home>
References: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1008231140320.9496@router.home>
	<20100823170610.GB2304@barrios-desktop>
	<alpine.DEB.2.00.1008231217100.9840@router.home>
Date: Tue, 24 Aug 2010 10:19:59 +0900
Message-ID: <AANLkTi=bbRHJ1Wzmm9FTiYzDyKj6PFGWmFqCZNHTNgEb@mail.gmail.com>
Subject: Re: [PATCH] compaction: fix COMPACTPAGEFAILED counting
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 2:17 AM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 24 Aug 2010, Minchan Kim wrote:
>
>> On Mon, Aug 23, 2010 at 11:41:49AM -0500, Christoph Lameter wrote:
>> > On Tue, 24 Aug 2010, Minchan Kim wrote
>> >
>> > > This patch introude new argument 'cleanup' to migrate_pages.
>> > > Only if we set 1 to 'cleanup', migrate_page will clean up the lists.
>> > > Otherwise, caller need to clean up the lists so it has a chance to postprocess
>> > > the pages.
>> >
>> > Could we simply make migrate_pages simply not do any cleanup?
>> > Caller has to call putback_lru_pages()?
>> >
>> Hmm. maybe I misunderstood your point.
>> Your point is that let's make whole caller of migrate_pagse has a responsibility
>> of clean up the list?
>
> Yes. All callers would be responsible for cleanup.

Yes. I hoped it but try to maintain API semantics.
But if you agree to change it, I will do it.
Will repost.
Thanks, Christoph.



-- 
Kind regards,
Minchan Kim
