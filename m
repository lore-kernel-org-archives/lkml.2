Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0F1Kqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:46:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38382 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0F1Kq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ks1b8RkSDrFH6qdDJZxgF5X5wzuk5YJ+AvSvTBU+u9MVEhiv+uoMz6sBL3LddJCvKP
         uY2Y9la44KbjoVPe2oTBWmpLeTjV0HLl5Tx1Y/XWD35hEermn7wPKrSBkhaOQ2bi0YnJ
         bXCwtqfVGBicFOZ+fIJn1Ham4C37S/zRHlJh4=
MIME-Version: 1.0
In-Reply-To: <20100628103508.3870.A69D9226@jp.fujitsu.com>
References: <20100625173002.8052.A69D9226@jp.fujitsu.com>
	<AANLkTikm9fXmGoE1phY7vgQcMsS9_FVAvPHgtt1hnvTV@mail.gmail.com>
	<20100628103508.3870.A69D9226@jp.fujitsu.com>
Date: Mon, 28 Jun 2010 19:46:26 +0900
Message-ID: <AANLkTilpsmxO527634ohmEmxg3rtRC_VwOgdgSy5Q4XN@mail.gmail.com>
Subject: Re: [PATCH] vmscan: zone_reclaim don't call disable_swap_token()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 10:37 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Fri, Jun 25, 2010 at 5:31 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Swap token don't works when zone reclaim is enabled since it was born.
>> > Because __zone_reclaim() always call disable_swap_token()
>> > unconditionally.
>> >
>> > This kill swap token feature completely. As far as I know, nobody want
>> > to that. Remove it.
>> >
>>
>> In f7b7fd8f3ebbb, Rik added disable_swap_token.
>> At that time, sc.priority in zone_reclaim is zero so it does make sense.
>> But in a92f71263a, Christoph changed the priority to begin from
>> ZONE_RECLAIM_PRIORITY with remained disable_swap_token. It doesn't
>> make sense.
>>
>> So doesn't we add disable_swap_token following as than removing?
>
> f7b7fd8f3ebbb says disable_swap_token was introduced to prevent OOM.
> but zone reclaim failure don't make OOM. instead, fallback to try_to_free_pages().

Indeed. I missed that.
Thanks, Kosaki.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
