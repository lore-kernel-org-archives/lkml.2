Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1BXDR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:17:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1BXDR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:17:26 -0500
Message-ID: <4D65CD81.4070203@zytor.com>
Date: Wed, 23 Feb 2011 19:16:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?TGludXMgTMO8c3Npbmc=?= <linus.luessing@web.de>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: Multicast snooping fixes and suggestions
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 03:19 PM, Linus Lüssing wrote:
> Hello everyone,
> 
> While testing the (very awesome!) bridge igmp/mld snooping support I came across
> two issues which are breaking IPv6 multicast snooping and IPv6
> non-link-local multicast on bridges with multicast snooping support enabled
> in general. The first two patches shall fix these issues.
> 
> The third one addresses a potential bug on little endian machines which I noticed
> during this little code reviewing. This patch is untested though, feedback welcome.
> 
> The fourth and fifth patch are a suggestion to also permit using the bridge multicast
> snooping feature for link local multimedia multicast traffic. Therefore
> using the transient multicast flag instead of the non-link-local scope criteria
> seems to be a suitable solution at least for IPv6, in my opinion. Let me know what
> you think about it.
> 

Hello,

I have just noticed that when using a Linux bridge, IPv6 often fails to
configure until some considerable time has passed, presumably some kind
of retry timer.  The dmesg shows:

[178292.449300] br0: port 1(eth0) entering learning state
[178292.449304] br0: port 1(eth0) entering learning state
[178302.536098] br0: no IPv6 routers present
[178307.416139] br0: port 1(eth0) entering forwarding state

... even though there is a configured and active IPv6 router on the network.

I have also seen some serious delays with DHCPv4 which presumably is due
to lost packets during bridge learning.

Are these packets likely to address that situation (or am I just plain
doing something stupid)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

