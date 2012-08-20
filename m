Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2HTJsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:48:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2HTJsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:48:09 -0400
Date: Mon, 20 Aug 2012 02:48:08 -0700 (PDT)
Message-Id: <20120820.024808.184015666899890382.davem@davemloft.net>
To: sjur.brandeland@stericsson.com
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel.martensson@stericsson.com
Subject: Re: [PATCH] caif: Do not dereference NULL in chnl_recv_cb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923B924D522@EXDCVYMBSTM005.EQ1STM.local>
References: <alpine.LNX.2.00.1208172230570.15699@swampdragon.chaosbits.net>
	<81C3A93C17462B4BBD7E272753C1057923B924D522@EXDCVYMBSTM005.EQ1STM.local>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Date: Mon, 20 Aug 2012 08:33:35 +0200

>> In net/caif/chnl_net.c::chnl_recv_cb() we call skb_header_pointer()
>> which may return NULL, but we do not check for a NULL pointer before
>> dereferencing it.
>> This patch adds such a NULL check and properly free's allocated memory
>> and return an error (-EINVAL) on failure - much better than crashing..
>> 
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Thank you for fixing this, the patch looks good to me.
> Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Applied, thanks.
