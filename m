Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1EMNz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:55:27 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:32795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab1EMNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:55:23 -0400
Subject: Re: [PATCH 2/3] net/rfkill/core.c: Avoid leaving freed data in a
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305294731-12127-2-git-send-email-julia@diku.dk>
References: <1305294731-12127-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:55:12 +0200
Message-ID: <1305294912.3468.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 15:52 +0200, Julia Lawall wrote:
> The list_for_each_entry loop can fail, in which case the list element is
> not removed from the list rfkill_fds.  Since this list is not accessed by
> the loop, the addition of &data->list into the list is just moved after the
> loop.
> 
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E,E1,E2;
> identifier l;
> @@
> 
> *list_add(&E->l,E1);
> ... when != E1
>     when != list_del(&E->l)
>     when != list_del_init(&E->l)
>     when != E = E2
> *kfree(E);// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> I have only verified that rfkill_fds is not accessed by the loop by
> inspecting the code.  If this analysis is not correct, the other solution
> would be to leave the list_add where it is and delete the element from the
> list explicitly.

Looks right to me, thanks!

johannes

