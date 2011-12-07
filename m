Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab1LGS7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:59:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38007 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab1LGS7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:59:47 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: "David S . Miller" <davem@davemloft.net>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 0/3] crypto: Add per-cpu transform helpers
Date: Wed,  7 Dec 2011 12:59:07 -0600
Message-Id: <1323284350-13784-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 11120718-9360-0000-0000-00000151FABA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes two new functions for the cryptographic library,
crypto_alloc_percpu_tfms() and crypto_free_percpu_tfms(), which assist users
in allocating and freeing per-cpu transforms.

It also includes typing wrappers for the compression algorithm class.

The reason for this patch is that during my work to enable page compression
via the cryptographic API in the zcache staging driver, and realized that I
had rewritten some per-cpu transform code that already exists in the
xfrm_ipcomp code.

In an effort to avoid duplication, this patchset moves the per-cpu code into
helper functions in the cryptographic library and makes the necessary
modifications to the xfrm_ipcomp code.

After this change is (hopefully) merged, I will submit the zcache driver
changes, which will be the second user of these helpers.

Seth Jennings (3):
  crypto: Add per-cpu transform alloc() and free()
  crypto: Add inline per-cpu wrappers for compression
  xfrm: Modify xfrm_ipcomp code to use new per-cpu helpers

 crypto/api.c           |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h |   28 +++++++++++++++++++++
 net/xfrm/xfrm_ipcomp.c |   34 ++++++--------------------
 3 files changed, 98 insertions(+), 26 deletions(-)

-- 
1.7.5.4

