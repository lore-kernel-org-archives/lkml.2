Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab0HUQ7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 12:59:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63254 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0HUQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 12:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=NSMY0kqawzpOPNTD7AZaK/RaDXQoEr3FIpm1zcPwOgq5cf/NAlZmV5R6azfqj5eT8z
         uKzntHC6Okcvk1qSNz9r0n0az0UHQ/BDqRbT3fYDp/uCCOby0sujheHUyCm1gA4riMBR
         JnMySVbxHBDbTLkszUL6/XwPlIl1qF3iWg3rU=
From: don.mullis@gmail.com
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] improve list_sort test
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	<1282386155.2358.43.camel@localhost>
Date: Sat, 21 Aug 2010 09:59:03 -0700
In-Reply-To: <1282386155.2358.43.camel@localhost> (Artem Bityutskiy's message
	of "Sat, 21 Aug 2010 13:22:35 +0300")
Message-ID: <87lj7zgaw8.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:
> Any feedback?
>
> I'm also going to add this patch to the series:
>
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH 1/7] lib/list_sort: improve comments
>
> Document the fact that 'list_sort()' can call the 'cmp()' function with
> 'a' == 'b' for the sake of 'cond_reshed()'.
>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  lib/list_sort.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/lib/list_sort.c b/lib/list_sort.c
> index 4b5cb79..d134b41 100644
> --- a/lib/list_sort.c
> +++ b/lib/list_sort.c
> @@ -93,6 +93,11 @@ static void merge_and_restore_back_links(void *priv,
>   * should sort before @b, and a positive value if @a should sort after
>   * @b. If @a and @b are equivalent, and their original relative
>   * ordering is to be preserved, @cmp must return 0.
> + *
> + * This function can be used in atomic context. This means that @cmp has to
> + * take care of calling 'cond_resched()' when needed. And 'list_sort()' will
> + * sometimes call @cmp with @a equivalent to @b, just to let the user call
> + * 'cond_resched()'.
>   */
>  void list_sort(void *priv, struct list_head *head,
>  		int (*cmp)(void *priv, struct list_head *a,
> -- 

Thanks, Artem.  I've prepared and tested locally a patch series that
brings in most of the series you sent earlier, and adds a few more
cleanups.  The one patch of yours that I did replace was the last one,
that modifies semantics of the correctness test.  My reasoning is that
the value of testing lies in exposing bugs, as economically as possible,
and your test wasn't exposing my power-of-two bug.  So I created an
alternative that's as simple as possible while picking at the corner
cases, e.g. power-of-two.

Last in my local patch series is the bug fix itself.  Setting
CONFIG_TEST_LIST_SORT and testing with all but the last patch applied
produces failure messages on the boot console.  Pushing the final "fix"
patch makes them go away :-)

Okay if I incorporate your comment addition, above, and post the series
for review?

Don
