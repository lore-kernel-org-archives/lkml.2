Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0J0TVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:21:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42103
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab0J0TVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:21:19 -0400
Date: Wed, 27 Oct 2010 12:21:43 -0700 (PDT)
Message-Id: <20101027.122143.02260950.davem@davemloft.net>
To: nelhage@ksplice.com
Cc: robert.olsson@its.uu.se, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, eugene@redhat.com
Subject: Re: [PATCH] pktgen: Remove a dangerous debug print.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
References: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>
Date: Wed, 27 Oct 2010 15:13:08 -0400

> We were allocating an arbitrarily-large buffer on the stack, which would allow a
> buggy or malicious userspace program to overflow the kernel stack.
> 
> Since the debug printk() was just printing exactly the text passed from
> userspace, it's probably just as easy for anyone who might use it to augment (or
> just strace(1)) the program writing to the pktgen file, so let's just not bother
> trying to print the whole buffer.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>

Only root can write to the pktgen control file.

Also, the debug feature really is used by people's pktgen scripts, you
can't just turn it off.
