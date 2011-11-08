Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1KHWNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:13:07 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:35487 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab1KHWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:13:05 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 0/2] AH fixes for asynchronous hash algorithms.
Date: Tue,  8 Nov 2011 17:12:43 -0500
Message-Id: <1320790365-29152-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two fixes for AH when using an asynchronous hmac driver.  Both
are -stable candidates as these problems appear to have been present
since AH was converted to use ahash way back in 2.6.33.

These code paths are not exercised when using the default software hash
implementations which do not use the ahash callbacks, but the issues can be
reproduced by using cryptd to create an asynchronous hash algorithm for
testing.

This driver could probably do with some cleanups to reduce the code
duplication (and thus test coverage) between the asynchronous callbacks
and synchronous code paths, which should help avoid these kind of
problems in the future.  These code paths apparently do not see a
lot of testing.  But that's for a later patch series.

Nick Bowler (2):
  ah: Correctly pass error codes in ahash output callback.
  ah: Read nexthdr value before overwriting it in ahash input callback.

 net/ipv4/ah4.c |    6 ++----
 net/ipv6/ah6.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

-- 
1.7.3.4

