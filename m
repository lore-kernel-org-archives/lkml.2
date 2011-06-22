Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1FVROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:14:06 -0400
Received: from mail.perches.com ([173.55.12.10]:3136 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab1FVROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:14:03 -0400
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
From: Joe Perches <joe@perches.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
In-Reply-To: <20110622165355.GB11803@albatros>
References: <20110622095341.GA3353@albatros>
	 <1308760683.10423.16.camel@Joe-Laptop>  <20110622165355.GB11803@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 10:14:01 -0700
Message-ID: <1308762841.10423.28.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 20:53 +0400, Vasiliy Kulikov wrote:
> On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> > > +	if ((c >= ' ' && c < 127) || c == '\n')
> > 	if (isprint(c))
> #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
> It slightly differs from what I've written.  It (1) lacks '\n',

You still need tab, so:

if (isprint(c) || isspace(c))

> (2) passes non-ASCII symbols.
> How would non-ASCII symbols look like if
> terminal doesn't support it?  (I don't know, merely asking).

I believe most would work fine.

Are there any lp01's or la36's still connected
to a serial console?

I don't know what would happen to a 7 bit
ascii only device.


