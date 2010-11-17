Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514Ab0KQU35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:29:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52481
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563Ab0KQU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:29:56 -0500
Date: Wed, 17 Nov 2010 12:30:21 -0800 (PST)
Message-Id: <20101117.123021.241451290.davem@davemloft.net>
To: segoon@openwall.com
Cc: kernel-janitors@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: tcp_probe: cleanup snprintf() use
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289754368-31660-1-git-send-email-segoon@openwall.com>
References: <1289754368-31660-1-git-send-email-segoon@openwall.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Sun, 14 Nov 2010 20:06:08 +0300

> snprintf() returns number of bytes that were copied if there is no overflow.
> This code uses return value as number of copied bytes.  Theoretically format
> string '%lu.%09lu %pI4:%u %pI4:%u %d %#x %#x %u %u %u %u\n' may be expanded
> up to 163 bytes.  In reality tv.tv_sec is just few bytes instead of 20, 2 ports
> are just 5 bytes each instead of 10, length is 5 bytes instead of 10.  The rest
> is an unstrusted input.  Theoretically if tv_sec is big then copy_to_user() would
> overflow tbuf.
> 
> tbuf was increased to fit in 163 bytes.  snprintf() is used to follow return
> value semantic.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
