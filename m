Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1BOXTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:19:34 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:42889 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1BOXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:19:32 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Multicast snooping fixes and suggestions
Date: Wed, 16 Feb 2011 00:19:16 +0100
Message-Id: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/uR+3OwNYtaDqi/37H5X2ecxYmYr9QqpXVkgA2
	8eEvg0GoQzglDOAKJBoQPUZXbcISwEULrjAW91UNkPDoKgFlV3
	Rjx6AS9aIuAhruxGWPSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

While testing the (very awesome!) bridge igmp/mld snooping support I came across
two issues which are breaking IPv6 multicast snooping and IPv6
non-link-local multicast on bridges with multicast snooping support enabled
in general. The first two patches shall fix these issues.

The third one addresses a potential bug on little endian machines which I noticed
during this little code reviewing. This patch is untested though, feedback welcome.

The fourth and fifth patch are a suggestion to also permit using the bridge multicast
snooping feature for link local multimedia multicast traffic. Therefore
using the transient multicast flag instead of the non-link-local scope criteria
seems to be a suitable solution at least for IPv6, in my opinion. Let me know what
you think about it.

Thanks for reviewing these patches.

Cheers,
Linus
