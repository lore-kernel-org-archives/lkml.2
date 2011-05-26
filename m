Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1EZDeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:34:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1EZDeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:34:22 -0400
Date: Wed, 25 May 2011 23:34:11 -0400 (EDT)
Message-Id: <20110525.233411.1372538972166578285.davem@davemloft.net>
To: msb@chromium.org
Cc: linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: sha1: modify sha1_update to use SHA1_BLOCK_SIZE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306379477-24552-1-git-send-email-msb@chromium.org>
References: <1306379477-24552-1-git-send-email-msb@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 May 2011 20:34:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mandeep Singh Baines <msb@chromium.org>
Date: Wed, 25 May 2011 20:11:17 -0700

> Plus some other minor cleanup.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

The temp[] buffer is explicitly places inside the inner most
basic block so that the compiler doesn't allocate the stack
space unless that code path is taken.

Besides the use of the SHA_* macros, I think your changes
actually make the code worse.
