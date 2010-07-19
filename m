Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0GSGEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:04:40 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:35675 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0GSGEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:04:39 -0400
Date: Mon, 19 Jul 2010 14:04:26 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] padata: cpumasks
Message-ID: <20100719060426.GA19696@gondor.apana.org.au>
References: <20100714142951.22817d0c@leibniz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714142951.22817d0c@leibniz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:29:51PM +0400, Dan Kruchinin wrote:
> This is my third attempt to send padata cpumasks patchset.
> The patchset includes fixes of all unclear things Steffen noted in previous two patchsets.
> Changes:
> 
> 1) Make two cpumasks in padata instead of one. The first cpumask is used by parallel workers and
> another is used by the workers doing serialization. Two distinguish cpumasks perform to build
> configuration where CPUs used by parallel and serial workers aren't intersect. It significantly
> improves performance.
> Each padata instance now includes notifier chain which can be used by users interested in instance's
> cpumask(serial or parallel) change. If one of cpumask is changed an event is generated.
> 
> 2) Add sysfs primitives to padata. Each padata instance contains kobject which can be embedded to any
> proper sysfs hierarchy. Padata kobject can be used to change or show serial or parallel cpumask.
> 
> 3) Add sysfs representation to pcrypt. Pcrypt now creates /sys/kernel/pcrypt/[pencrypt|pdecrypt] during
> module loading phase. pencrypt and pdecrypt directories are represented by kobjects of padata instances
> that belongs to pencrypt and pdecrypt respectively. Using this sysfs interface user can change and read
> serial and parallel cpumasks of both instances.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
