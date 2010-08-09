Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0HIF7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:59:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45952 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0HIF7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tOtG2BJMAv/0csdh61JXSr6C90bbWzE58ENfGPUC492uWqMXCExfdiMk654qohx5Yn
         JspjkFmRlfoBESpCaIi2eoz9jHQnLcj6qtSG9p08UuHNdfowvMK7DyVjq9H4NDvXs+QB
         /AqVyiXygdBcVQYdqsGGMr/e+wWCNOaBVbHU4=
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1281261789.2384.11.camel@localhost>
	 <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
	 <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 08:59:49 +0300
Message-ID: <1281333589.2332.2.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 13:07 -0700, Don Mullis wrote:
> On Sun, Aug 8, 2010 at 12:31 PM, Don Mullis <don.mullis@gmail.com> wrote:
> > Artem Bityutskiy <dedekind1@gmail.com> writes:
> >> Actually, your 'list_sort()' version does have a problem. I found out
> >> that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
> >> cases 'a' and 'b' can point to something which is not a valid element of
> >> the original list. Probably a senitel or something like that.
> 
> Looks like if the original list is a POT in length, the first callback
> from line 73 will pass a==b both pointing to the original list_head.
> Would you be able to test this fix?
> 
> --- linux-2.6.orig/lib/list_sort.c
> +++ linux-2.6/lib/list_sort.c
> @@ -70,7 +70,7 @@ static void merge_and_restore_back_links
>                  * element comparison is needed, so the client's cmp()
>                  * routine can invoke cond_resched() periodically.
>                  */
> -               (*cmp)(priv, tail, tail);
> +               (*cmp)(priv, tail->next, tail->next);
> 
>                 tail->next->prev = tail;
>                 tail = tail->next;

Hi, thanks. I'm out of office, and probably will be able to do this few
weeks later.

Artem.

