Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab1LJP5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 10:57:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46951 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1LJP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 10:57:15 -0500
MIME-Version: 1.0
In-Reply-To: <1323529084.16764.5.camel@twins>
References: <20111210104341.592561407@chello.nl>
	<20111210104840.295857663@chello.nl>
	<CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	<1323529084.16764.5.camel@twins>
Date: Sat, 10 Dec 2011 23:57:14 +0800
Message-ID: <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 10:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2011-12-10 at 22:07 +0800, Ming Lei wrote:
>> > While true, it fails to show why this is a problem. I say it is not a
>>
>> IMO, the added two barriers are pairs of the implicit barrier in kref_put, so
>> that we can order between kref_init/kref_get and kref_put.
>
> Yeah so?

I think so, see below:


CPU0			CPU1

atomic_set(v)
smp_mb()
				smp_mb()
				atomic_dec_and_test(v)

Without the barrier after atomic_set, CPU1 may see a stale
value of v first, then decrease it, so may miss a release operation.

The pair of smp_mb can make order between atomic_set
and atomic_dec_and_test, can't it?

> If there's a destruction race with kref_put() the barrier won't

Sorry, could you say what the destruction race is?

> solve it. Other than that the actual order of get/put is irrelevant.


thanks,
-- 
Ming Lei
