Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab0HDF6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:58:25 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:33872 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0HDF6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:58:24 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: nigel@tuxonice.net
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <0401585627.965401975@rexursive.com>
References: <0401585627.965401975@rexursive.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 15:58:22 +1000
Message-ID: <1280901502.2591.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 15:12 +1000, Bojan Smojver wrote:
> OK, I will check. I kinda remember the docs just saying to select the 
> above. 

Looks to me the dependencies go the other way around (i.e. crypto
depends on LZO, not LZO on crypto):
-----------------
config CRYPTO_LZO
        tristate "LZO compression algorithm"
        select CRYPTO_ALGAPI
        select LZO_COMPRESS
        select LZO_DECOMPRESS
        help
          This is the LZO algorithm.
-----------------

So, one needs LZO_COMPRESS/DECOMPRESS for CYPTO_LZO. But, given we just
need straight compression/decompression, this should not be needed, if
I'm understanding things correctly.

-- 
Bojan

