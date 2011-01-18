Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1ARRQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:16:51 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46017 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752502Ab1ARRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:16:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=k/6fUreMc7J1AN+Gewy0DifdZyQMLYdOytyKqwMggzFL4C+ZXx/jD6vPuR2RLDWtK/S9bFwRCY6VC+89O0ioUX5FqfoegYGHg7hweggCd/OQs794vhcBbXHaFQScys57;
Date: Tue, 18 Jan 2011 09:16:46 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>, Eric Anholt <eric@anholt.net>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915 completely broken with KMS off
Message-ID: <20110118091646.73a5014c@jbarnes-desktop>
In-Reply-To: <20110118115701.GA11952@gondor.apana.org.au>
References: <20110118115701.GA11952@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 22:57:01 +1100
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Hi:
> 
> I just upgraded my kernel on a machine with i915 and it has
> started crashing constantly with messages like this:
[snip]
> The cause is this changeset:
> 
> commit 8187a2b70e34c727a06617441f74f202b6fefaf9
> Author: Zou Nan hai <nanhai.zou@intel.com>
> Date:   Fri May 21 09:08:55 2010 +0800
> 
>     drm/i915: introduce intel_ring_buffer structure (V2)
> 
> This changeset completely broke i915 without KMS because the new
> intel_ring_buffer structure is never initialised with KMS off,
> unless the ioctl I915_GEM_ENTERVT is invoked.
> 
> So without invoking that ioctl, the kernel will always crash
> whenever the i915 driver dereferences pointers on the render_ring
> data structure.
> 
> Or is this a hint to get people to convert to KMS :)

Heh, well that would be one option for you. :)

The breakage was unintentional though; I imagine Chris will have an
idea of how to fix it quickly for you.

-- 
Jesse Barnes, Intel Open Source Technology Center
