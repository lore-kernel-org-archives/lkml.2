Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1EXFqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:46:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51883 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1EXFqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EOUCAh+C4dzLotyweA8h0mZsUBVUByha7TyckIXYfFqCGy2tEZD6oApLuaI60p79h8
         4a59sfBrMbqPDFrwxtXH15N++TFjvQQ5oydAOgqNE15RuXuAXIEAGNRmEM0P4AKJBWKz
         FYxbnstenCTsIyLICcl+rrNnA/mj7qUyUlIuo=
Subject: Re: [PATCH v2]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>
In-Reply-To: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
References: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 07:45:58 +0200
Message-ID: <1306215958.2638.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 mai 2011 à 22:40 -0700, Justin P. Mattock a écrit :
> The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init, 
> so that it prints out just the fullname of vlan and the version number.
> 
> before:
> 
> [   30.438203] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
> [   30.441542] All bugs added by David S. Miller <davem@redhat.com>
> 
> after:
> 
> [   31.513910] 802.1Q VLAN Support v1.8
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Joe Perches <joe@perches.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Ben Greear <greearb@candelatech.com>
> ---
>  net/8021q/vlan.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index b2274d1..9df3fcb 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -673,8 +673,7 @@ static int __init vlan_proto_init(void)
>  {
>  	int err;
>  
> -	pr_info("%s v%s %s\n", vlan_fullname, vlan_version, vlan_copyright);
> -	pr_info("All bugs added by %s\n", vlan_buggyright);
> +	pr_info("%s v%s\n", vlan_fullname, vlan_version);
>  
>  	err = register_pernet_subsys(&vlan_net_ops);
>  	if (err < 0)

This reminds me a discussion with Harald Welte in netfilter workshop
2010.

Sometime these strings help lot guys working to fight GPL violations.




