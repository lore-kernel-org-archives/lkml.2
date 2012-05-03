Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2ECM4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:56:48 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52537 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab2ECM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:56:45 -0400
Message-ID: <1336049801.12189.31.camel@cumari.coelho.fi>
Subject: Re: [PATCH] wl12xx: fix size of two memset's in
 wl1271_cmd_build_arp_rsp()
From: Luciano Coelho <coelho@ti.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 15:56:41 +0300
In-Reply-To: <alpine.LNX.2.00.1204222255460.27455@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204222252000.27455@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1204222255460.27455@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-22 at 22:57 +0200, Jesper Juhl wrote:
> On Sun, 22 Apr 2012, Jesper Juhl wrote:
> 
> > We currently do this:
> > 
> > int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
> > ...
> > 	struct wl12xx_arp_rsp_template *tmpl;
> > 	struct ieee80211_hdr_3addr *hdr;
> > ...
> > 	tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
> > 	memset(tmpl, 0, sizeof(tmpl));
> > ...
> > 	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
> > 	memset(hdr, 0, sizeof(*hdr));
> > ...
> > 
> > I believe we want to set the entire structures to 0 with those
> > memset() calls, not just zero the initial part of them (size of the
> > pointer bytes).
> > 
> 
> Sorry, I accidentally copied that code from the fixed version. The above 
> should read:
> 
> 
> We currently do this:
> 
> int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
> ...
>       struct wl12xx_arp_rsp_template *tmpl;
>       struct ieee80211_hdr_3addr *hdr;
> ...
>       tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
>       memset(tmpl, 0, sizeof(tmpl));
> ...
>       hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
>       memset(hdr, 0, sizeof(hdr));
> ...
> 
> I believe we want to set the entire structures to 0 with those
> memset() calls, not just zero the initial part of them (size of the
> pointer bytes).
> 
> 
> 
> 
> 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---

Applied with the fixed commit log and merged into the new directory
structure.  Thanks Jesper!


