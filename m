Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1AQJjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab1AQJjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:39:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201101170044.p0H0iLQW087457@www262.sakura.ne.jp>
References: <201101170044.p0H0iLQW087457@www262.sakura.ne.jp> <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp> <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net> <201101170039.p0H0d1f5085735@www262.sakura.ne.jp> <201101170041.p0H0ffFE086481@www262.sakura.ne.jp> 
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: dhowells@redhat.com, safford@watson.ibm.com, safford@us.ibm.com,
        jj@chaosbits.net, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] trusted-keys: avoid scattring va_end()
Date: Mon, 17 Jan 2011 09:39:35 +0000
Message-ID: <3630.1295257175@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> From 65b41710a476deae2e0899a4df40c02d199a4ee3 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Jan 2011 09:27:27 +0900
> Subject: [PATCH 3/3] trusted-keys: avoid scattring va_end()
> 
> We can avoid scattering va_end() within the
> 
>   va_start();
>   for (;;) {
> 
>   }
>   va_end();
> 
> loop, assuming that crypto_shash_init()/crypto_shash_update() return 0 on
> success and negative value otherwise.
> 
> Make TSS_authhmac()/TSS_checkhmac1()/TSS_checkhmac2() similar to TSS_rawhmac()
> by removing "va_end()/goto" from the loop.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: David Howells <dhowells@redhat.com>
