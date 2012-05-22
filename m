Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2EVSrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:47:13 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2EVSrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:47:11 -0400
Message-ID: <1337712399.4470.5.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH] rfkill: Add handling when rfkill's type is
 RFKILL_TYPE_ALL.
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Hung <alex.hung@canonical.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 22 May 2012 20:46:39 +0200
In-Reply-To: <1337589439-14605-1-git-send-email-alex.hung@canonical.com>
References: <1337589439-14605-1-git-send-email-alex.hung@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 16:37 +0800, Alex Hung wrote:
> This rfkill type is supposed to be able to toggles the status of all wireless
> devices; however, no wireless devices will register itself with type 
> RFKILL_TYPE_ALL and thus it was previously ignored in __rfkill_switch_all.
> 
> Signed-off-by: Alex Hung <alex.hung@canonical.com>
> ---
>  net/rfkill/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 5be1957..84dd71a 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -324,7 +324,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
>  
>  	rfkill_global_states[type].cur = blocked;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		if (rfkill->type != type)
> +		if (rfkill->type != type && type != RFKILL_TYPE_ALL)
>  			continue;

Sorry, I accidentally replied to this in private and then Alex replied
but it all got lost.

He said he was going to change the eeepc use KEY_RFKILL instead of
KEY_WLAN to switch all types...

So I guess what this change really does is make __rfkill_switch_all() be
able to not only switch all devices of a given type, but also be able to
switch all devices of all types.

Alex, can you please rewrite the commit log to make that clearer?

johannes

