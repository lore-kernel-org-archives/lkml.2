Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1AaW1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:27:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34131 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab1AaW1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fIs5k/90cMZFDYBY5cBJ9EALLWgNg/cFh8tesAK+/7UNdeY6FT7yhQIGLciJiKxC9W
         e9UfTw90UR7B4eXdZp3dfcuwCCLJuM4yttftPEtMW+A3uDkVtZ3IWQRFb4VpM8ifIXzT
         eOeHJ6WMx/gb7QxYGN95xYsXA52nRrQ8o5Z84=
MIME-Version: 1.0
In-Reply-To: <1296482635-13421-2-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-2-git-send-email-hannes@cmpxchg.org>
Date: Tue, 1 Feb 2011 07:27:36 +0900
Message-ID: <AANLkTikB+_Qgb0OA8mkEhftAvH3eZz_PCTqrzCoZUqEy@mail.gmail.com>
Subject: Re: [patch 1/3] memcg: prevent endless loop when charging huge pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:03 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> The charging code can encounter a charge size that is bigger than a
> regular page in two situations: one is a batched charge to fill the
> per-cpu stocks, the other is a huge page charge.
>
> This code is distributed over two functions, however, and only the
> outer one is aware of huge pages.  In case the charging fails, the
> inner function will tell the outer function to retry if the charge
> size is bigger than regular pages--assuming batched charging is the
> only case.  And the outer function will retry forever charging a huge
> page.
>
> This patch makes sure the inner function can distinguish between batch
> charging and a single huge page charge.  It will only signal another
> attempt if batch charging failed, and go into regular reclaim when it
> is called on behalf of a huge page.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
