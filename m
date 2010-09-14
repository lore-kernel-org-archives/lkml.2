Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0INFR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:17:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0INFRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:17:23 -0400
Subject: Re: [PATCH 2/2] mac80211: fix compilation warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kalle.valo@iki.fi>, Felix Fietkau <nbd@openwrt.org>,
        Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1284289829-25425-3-git-send-email-felipe.contreras@gmail.com>
References: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
	 <1284289829-25425-3-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 07:17:12 +0200
Message-ID: <1284441432.3704.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 14:10 +0300, Felipe Contreras wrote:

>  	struct ieee80211_hdr hdr;
> -	struct ieee80211s_hdr mesh_hdr;
>  	const u8 *encaps_data;
>  	int encaps_len, skip_header_bytes;
>  	int nh_pos, h_pos;
> @@ -1755,7 +1754,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		hdrlen = 30;
>  		break;
>  #ifdef CONFIG_MAC80211_MESH
> -	case NL80211_IFTYPE_MESH_POINT:
> +	case NL80211_IFTYPE_MESH_POINT: {
> +		struct ieee80211s_hdr mesh_hdr;
> +

...

might be nicer to just add __maybe_unused.

johannes

