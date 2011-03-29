Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1C2QpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1C2QpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:45:11 -0400
Date: Tue, 29 Mar 2011 12:44:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Blkio: Apply two policies on one IO process
Message-ID: <20110329164445.GB24485@redhat.com>
References: <201103300000153595438@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103300000153595438@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 12:00:16AM +0800, Lina Lu wrote:
> Hi Vivek,
>       As the weight and throttle policies are on different layers, someone can apply 
> these two policies on one IO pid at one time. And the IO bandwidth will be controlled
> with the more stringent policy.
>       If someone first set two policies on one pid, then want to remove the weight
> policy, he must first echo the pid to parent dir's tasks, then echo the throttle policy
> to parent dir's blkio.throttle_xx_xx_device. These steps seen to be cumbersome.
>       This is because the weight policy can be applied independence, but the throttle
> policy is always accompany with the weight policy(default 500). I think it will be 
> better that these policies are independent of each other. What is your opinion?
>       Additional, do you recommend applying two policies on one IO process?

How do you want to make these independent?

- If one does not want weight based policy, one can change IO scheduler
  to deadline.

- If one does not want throttling policy, do not apply throttling limits.

Thanks
Vivek
