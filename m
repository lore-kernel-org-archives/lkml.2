Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0G0KBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:01:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36587 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0G0KBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UmgfNmaryi8y81lSzkKq4iFdTApVyY1EPdYt9/ei3GLJWgYOGWmwLUBSo4cT2CLM7w
         LqoLrYWzV0Zs8tdpY54HPs5NXh9g5+kag69kkteVoKaeWJ1pqjuRl5k7XoQbcF6xB/W0
         da8LElbEfQSPMEDd/VKY9g+hk2SPiMGGMKvB0=
MIME-Version: 1.0
In-Reply-To: <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1007261136160.5438@router.home>
	<pfn.valid.v4.reply.1@mdm.bga.com>
	<AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
	<pfn.valid.v4.reply.2@mdm.bga.com>
	<20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 27 Jul 2010 19:01:14 +0900
Message-ID: <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Milton Miller <miltonm@bga.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Tue, Jul 27, 2010 at 5:13 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com>
>> Perhaps the mem_section array.  Using a symbol that is part of
>> the model pre-checks can remove a global symbol lookup and has the side
>> effect of making sure our pfn_valid is for the right model.
>>
>
> But yes, maybe it's good to make use of a fixed-(magic)-value.

fixed-magic-value?
Yes. It can be good for some debugging.
But as Christoph pointed out, we need some strict check(ex,
PG_reserved) for preventing unlucky valid using of magic value in
future.
But in fact I have a concern to use PG_reserved since it can be used
afterward pfn_valid normally to check hole in non-hole system. So I
think it's redundant.

Hmm..

-- 
Kind regards,
Minchan Kim
