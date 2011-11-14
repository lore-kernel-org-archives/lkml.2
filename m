Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1KNVnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:43:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44466 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab1KNVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:43:09 -0500
Date: Mon, 14 Nov 2011 21:43:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regmap: Do not call regcache_exit from
 regcache_lzo_init error path
Message-ID: <20111114214304.GI6528@opensource.wolfsonmicro.com>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
 <1321263619-25891-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321263619-25891-5-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:40:19AM +0100, Lars-Peter Clausen wrote:
> Calling regcache_exit from regcache_lzo_init is a layering violation and
> might cause double frees. In case of an error only free those structures which
> have been allocated in this function.

You should also be explaining here why the cleanup done the core exit
function is still being done when the code is changed this way.  The
fact that it may be a layering violation doesn't mean that the cleanup
is actually being done anywhere else...
