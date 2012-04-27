Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366Ab2D0U37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:29:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45629 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab2D0U36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:29:58 -0400
Date: Fri, 27 Apr 2012 16:29:25 -0400 (EDT)
Message-Id: <20120427.162925.2185774349490743693.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
References: <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
	<20120427.152404.2292425516870981391.davem@davemloft.net>
	<CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 13:29:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 12:56:20 -0700

>  - when reading, consider a pipe buffer to be "spent" when any of the
> data has been read

So basically any sized read empties the entire pipe, right?

As long as we never generate multiple messages at the same
time, I guess this would work.

Otherwise we can't use this approach without some adjustments.
