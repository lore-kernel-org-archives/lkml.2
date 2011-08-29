Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1H2QJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:09:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1H2QJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:09:40 -0400
Date: Mon, 29 Aug 2011 12:09:19 -0400 (EDT)
Message-Id: <20110829.120919.1151736227385892166.davem@davemloft.net>
To: nmav@gnutls.org
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E5B4083.6050001@gnutls.org>
References: <4E5A3FCC.2030504@gnutls.org>
	<20110828.163554.2024158531156183815.davem@davemloft.net>
	<4E5B4083.6050001@gnutls.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 09:09:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Date: Mon, 29 Aug 2011 09:32:19 +0200

> On 08/28/2011 10:35 PM, David Miller wrote:
> 
>>> The benchmark idea was to test the speed of initialization, encryption
>>> and deinitiation, as well as the encryption speed alone. These are the
>>> most common use cases of the frameworks (i.e. how they would be used
>>> by a cryptographic library).
>> Be sure to use splice() with AF_ALG for maximum performance.
>> For example, see the test program below.  You'll need to replace
>> "8192" with whatever the page size is on your cpu.
> 
> As I understand with splice you can encrypt only page aligned data
> that span a multiple of pages. This is a very uncommon case. My
> benchmark targets the generic case, i.e., the way this interface will
> be used in crypto libraries like gnutls.

Only the buffer you use must have these properties, you can use
whatever lengths you like.
