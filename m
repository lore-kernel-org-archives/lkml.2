Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0JHNJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:09:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47708 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab0JHNJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:09:22 -0400
Date: Fri, 8 Oct 2010 18:39:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
Message-ID: <20101008130916.GC5327@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101005124521.GA2602@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101005124521.GA2602@darkstar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young <hidave.darkstar@gmail.com> [2010-10-05 20:45:21]:

> Balloon could cause guest memory oom killing and panic.
> 
> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
> 
> At the same time add a mutex to protect balloon operations
> because we need leak balloon in oom notifier and give back freed value. 
> 
> Thanks Anthony Liguori for his sugestion about inflate retrying.
> Sometimes it will cause endless inflate/oom/delay loop,
> so I think next step is to add an option to do noretry-when-oom balloon.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Won't __GFP_NORETRY prevent OOM? Could you please describe how you
tested the patch?

-- 
	Three Cheers,
	Balbir
