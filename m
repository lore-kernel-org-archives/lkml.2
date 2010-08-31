Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0HaDqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 23:46:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48421 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0HaDqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 23:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T8UUQpk1ZZngFP2inHHEpL6eBAOoZMs2Mlth8hGZzJZAQm0LvRLugNT/EAbR0fvKBR
         hQpnfq/UpFALbVoyxVtqS165O5nfTDlgdTVpeV0lQXHk+PVoUSAv2keewuYBtkqB4hlH
         qNKfhSK4KavqIPMhNbv/BCXyhHRevhU9Bsu+w=
MIME-Version: 1.0
In-Reply-To: <4C7C6959.3030801@redhat.com>
References: <AANLkTi==mQh31PzuNa1efH2WM1s-VPKyZX0f5iwb54PD@mail.gmail.com>
	<AANLkTinqm0o=AfmgFy+SpZ1mrdekRnjeXvs_7=OcLii8@mail.gmail.com>
	<20100831095140.87C7.A69D9226@jp.fujitsu.com>
	<AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
	<4C7C6959.3030801@redhat.com>
Date: Tue, 31 Aug 2010 12:46:53 +0900
Message-ID: <AANLkTik=6kRdz0LJnRRhddW_Lp8osis-4Y7EGc4u5x0z@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:30 AM, Rik van Riel <riel@redhat.com> wrote:
> On 08/30/2010 09:23 PM, Minchan Kim wrote:
>
>> Ying's one and mine both has a same effect.
>> Only difference happens swap is full. My version maintains old
>> behavior but Ying's one changes the behavior. I admit swap full is
>> rare event but I hoped not changed old behavior if we doesn't find any
>> problem.
>> If kswapd does aging when swap full happens, is it a problem?
>
> It may be a good thing, since swap will often be freed again
> (when something is swapped in, or exits).
>
> Having some more anonymous pages sit on the inactive list
> gives them a chance to get used again, potentially giving
> us a better chance of preserving the working set when swap
> is full or near full a lot of the time.

Do you mean we would be better to do background aging when swap is full?
I wanted it. So I used total_swap_pages to protect working set when
swap is full.
But Ying and KOSAKI's don't like it since it makes code inconsistent
or not simply.
And I agree it's rare event as KOSAKI mentioned.

Hmm... What do you think about it?

If you don't mind, I will resend latest version(use nr_swap_page usage
and compile out inactive_anon_is_low in case of !CONFIG_SWAP).


-- 
Kind regards,
Minchan Kim
