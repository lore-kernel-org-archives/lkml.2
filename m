Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2ENVjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:39:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65423 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab2ENVja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <1337029683.8512.626.camel@edumazet-glaptop>
References: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com> <1337029683.8512.626.camel@edumazet-glaptop>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 14 May 2012 23:39:09 +0200
Message-ID: <CA+1xoqfWR+BA4xqqG+8SzVGYSH1z6nu_=iEFX7XoZzMhv_GvqA@mail.gmail.com>
Subject: Re: [PATCH] net: codel: fix build errors
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:08 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Anonymous unions are fine, we use them a lot in kernel.

While we use them a lot, we don't try initializing them that often.

> Please fix the initializers instead in fq_codel_dump_stats(), because
> these two #define are not very nice.

The only method I know of fixing that up is getting braces around them
in the initializer, which is hacky and will break every time a new
member is added to the struct before the anonymous union. Is there a
different solution?
