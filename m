Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1DEWZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:25:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63594 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1DEWZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y7zbFYYQMpiMER4qTqU2pL4fkx6T5QxTGaD41bkJbl/VGR5GhOGfUh9aXFasRRQYbe
         UOmnCXp/fHSxPsbVpb3Bpzht7tNBBES4WB36lFoyOFJ7m80/vq1Gy1CK6vGo9sQ1UjYN
         etFh5Tuj4B+0FAsgoXzChGxDkBTczgkmFlknI=
MIME-Version: 1.0
In-Reply-To: <1302015561-21047-30-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-30-git-send-email-mmarek@suse.cz>
Date: Tue, 5 Apr 2011 18:25:21 -0400
Message-ID: <BANLkTimxWBC9J5+gDTkZe-J19fkr9vyLcw@mail.gmail.com>
Subject: Re: [PATCH 29/34] tipc: Drop __TIME__ usage
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 10:59 AM, Michal Marek <mmarek@suse.cz> wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.

I'll make sure this gets bundled into the next batch of tipc updates
I proxy to DaveM.   The ccache users should be happier.

Thanks,
Paul.

>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Allan Stephens <allan.stephens@windriver.com>
> Cc: tipc-discussion@lists.sourceforge.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  net/tipc/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/tipc/core.c b/net/tipc/core.c
> index e071579..33532fe 100644
> --- a/net/tipc/core.c
> +++ b/net/tipc/core.c
> @@ -185,8 +185,7 @@ static int __init tipc_init(void)
>        if (tipc_log_resize(CONFIG_TIPC_LOG) != 0)
>                warn("Unable to create log buffer\n");
>
> -       info("Activated (version " TIPC_MOD_VER
> -            " compiled " __DATE__ " " __TIME__ ")\n");
> +       info("Activated (version " TIPC_MOD_VER ")\n");
>
>        tipc_own_addr = 0;
>        tipc_remote_management = 1;
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
