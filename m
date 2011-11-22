Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1KVHyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab1KVHyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:54:38 -0500
Date: Tue, 22 Nov 2011 08:56:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build warning after merge of the wireless-next tree
Message-ID: <20111122075640.GB2199@redhat.com>
References: <20111122142502.ca68d0a1640b2a8480d51ad2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122142502.ca68d0a1640b2a8480d51ad2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 02:25:02PM +1100, Stephen Rothwell wrote:
> After merging the wireless-next tree, today's linux-next build
> (x86_64_allmodconfig) produced this warning:
> 
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: data definition has no type or storage class [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: data definition has no type or storage class [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: parameter names (without types) in function declaration [enabled by default]
> 
> This indicates that this file needs to include export.h.

I think adding export.h to debug.c should be part of current
wireless-next manual merge (debug.c include old iwl-debugfs.c,
which was modified with export.h). If not, I'm posting patch
with fix in the following email.

Thanks
Stanislaw
