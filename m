Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0F3NBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:01:55 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:37801 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab0F3NBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:01:54 -0400
Date: Wed, 30 Jun 2010 15:03:15 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <kruchinin@altell.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/2] padata: Separate cpumasks for cb_cpus and parallel
 workers
Message-ID: <20100630130315.GE10072@secunet.com>
References: <20100629203415.01c953e4@leibniz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629203415.01c953e4@leibniz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Jun 2010 13:01:46.0261 (UTC) FILETIME=[65186C50:01CB1854]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 08:34:15PM +0400, Dan Kruchinin wrote:
> 1) Two separate cpumasks for parallel and serial workers
> 2) padata_alloc does not takes cpumask as its argument, instead
> it uses a default one. __padata_alloc takes two cpumasks as its
> arguments: one for parallel workers and another one for serial.
> 3) I made padata_cpu_hash a public function to reduce code size(in
> several places in pcrypt.c there is near the same code(for getting cpu
> hash) as in padata_cpu_hash)
> 

Plead keep padata_cpu_hash() static to padata. If this becomes
part of the padata API it's not that easy to change it anymore.
You could add a similar function to pcrypt and use this function
there wehenver it's needed.
