Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1LSGnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:43:01 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51357 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082Ab1LSGm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:42:58 -0500
Message-ID: <1324276976.23473.4.camel@joe2Laptop>
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool
 (net & drivers/net)
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        pawel.moll@arm.com, netdev@vger.kernel.org
Date: Sun, 18 Dec 2011 22:42:56 -0800
In-Reply-To: <87ehw1nm9r.fsf@rustcorp.com.au>
References: <877h1ysenl.fsf@rustcorp.com.au>
	 <1323920752.29500.11.camel@joe2Laptop> <87k45xqvfs.fsf@rustcorp.com.au>
	 <20111215.231517.185391590658983405.davem@davemloft.net>
	 <87ehw1nm9r.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 16:19 +1030, Rusty Russell wrote:
> diff --git a/drivers/net/ethernet/amd/amd8111e.h b/drivers/net/ethernet/amd/amd8111e.h
[]
> @@ -808,8 +808,8 @@ typedef enum {
[]
> +static bool coalesce[MAX_UNITS] = {1,1,1,1,1,1,1,1};
> +static bool dynamic_ipg[MAX_UNITS] = {0,0,0,0,0,0,0,0};

Perhaps these array initializations could/should be:

static bool coalesce[MAX_UNITS] = { [0 ... MAX_UNITS - 1] = true };
static bool dynamic_irq[MAX_UNITS] = { [0 ... MAX_UNITS - 1] = false };

in a separate patch maybe.


