Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab1BIFwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:52:30 -0500
Received: from 1wt.eu ([62.212.114.60]:60444 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1BIFw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:52:29 -0500
Date: Wed, 9 Feb 2011 06:52:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Jayson R. King" <dev@jaysonking.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>
Subject: Re: [stable] 2.6.27.58-rc1 build error Re: [PATCH 21/23] hvc_console: Fix race between hvc_close and hvc_remove
Message-ID: <20110209055224.GF16288@1wt.eu>
References: <4D52080A.1090100@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52080A.1090100@jaysonking.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:20:42PM -0600, Jayson R. King wrote:
> drivers/char/hvc_console.c: In function 'hvc_open':
> drivers/char/hvc_console.c:315: error: implicit declaration of function 
> 'tty_kref_get'
> drivers/char/hvc_console.c:324: warning: assignment makes pointer from 
> integer without a cast
> drivers/char/hvc_console.c:341: error: implicit declaration of function 
> 'tty_kref_put'
> drivers/char/hvc_console.c: In function 'hvc_poll':
> drivers/char/hvc_console.c:558: warning: assignment makes pointer from 
> integer without a cast
> drivers/char/hvc_console.c: In function 'hvc_remove':
> drivers/char/hvc_console.c:759: warning: assignment makes pointer from 
> integer without a cast
> 
> I don't see a tty_kref_get or tty_kref_put on 2.6.27. Those functions 
> first appeared in 2.6.28.

Oh indeed, and the ->kref struct member did not even exist in 2.6.27.
Let's drop the patch then, we don't want to add the kref everywhere,
it would have to be ported to other users.

Thanks!
Willy

