Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1LJO65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:58:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55176 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1LJO64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:58:56 -0500
Message-ID: <1323529084.16764.5.camel@twins>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Date: Sat, 10 Dec 2011 15:58:04 +0100
In-Reply-To: <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.295857663@chello.nl>
	 <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 22:07 +0800, Ming Lei wrote:
> > While true, it fails to show why this is a problem. I say it is not a
> 
> IMO, the added two barriers are pairs of the implicit barrier in kref_put, so
> that we can order between kref_init/kref_get and kref_put. 

Yeah so? If there's a destruction race with kref_put() the barrier won't
solve it. Other than that the actual order of get/put is irrelevant.
