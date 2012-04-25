Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2DYO3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:29:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2DYO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:29:37 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 15:29:36 +0100
Message-ID: <CANd1uZ=btyt8q5vbhFjh06bij2xaqGxMLjHf10ORk-XQq-gSxQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] math128: Introduce {mult,add,cmp}_u128
From: Jay Foad <jay.foad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef shl_u128
> +static inline u128 shl_u128(u128 x, unsigned int n)
> +{
> +	u128 res;
> +
> +	if (n < 64) {
> +		res.hi = x.hi << n;
> +		res.hi |= x.lo >> (64 - n);

This is undefined when n == 0.

> +		res.lo = x.lo << n;
> +	} else {
> +		res.lo = 0;
> +		res.hi = x.lo << (n - 64);
> +	}
> +
> +	return res;
> +}
> +#endif /* shl_u128 */
> +
> +#ifndef shr_u128
> +static inline u128 shr_u128(u128 x, unsigned int n)
> +{
> +	u128 res;
> +
> +	if (n < 64) {
> +		res.lo = x.lo >> n;
> +		res.lo |= x.hi << (64 - n);

Likewise.

> +		res.hi = x.hi >> n;
> +	} else {
> +		res.hi = 0;
> +		res.lo = x.hi >> (n - 64);
> +	}
> +
> +	return res;
> +}
> +#endif /* shr_u128 */

Jay.
