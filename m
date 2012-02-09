Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab2BIWg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:36:59 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48112 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab2BIWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:36:58 -0500
Message-ID: <4F344A85.4070005@windriver.com>
Date: Thu, 9 Feb 2012 17:36:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: 8250 move broke the build on sparc
References: <20120209.163009.1594369939327153054.davem@davemloft.net>
In-Reply-To: <20120209.163009.1594369939327153054.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-09 04:30 PM, David Miller wrote:
> 
> Commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b ("serial: group all
> the 8250 related code together") broke the build on sparc.
> 
> You really can't move 8250.c around without adjusting the "" includes
> such as the one for "suncore.h".

Understood.  As I mentioned earlier[1], I'd done sparc builds, but
completely missed the fact that sparc didn't have 8250 enabled
by default. Good intentions, but bad execution.  Sorry about
the fallout.  

> 
> Simply changing "suncore.h" to "../suncore.h" fixes things, but that's
> pretty ugly if you ask me.

It only uses suncore.h for sunserial_register_minors (and unreg).
Would you like it better if I killed all ifdefs and the include
and used an incantation of weak instead?  Might be cleaner....

P.

[1] https://lkml.org/lkml/2012/2/3/355
