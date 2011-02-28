Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1B1P4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:56:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1B1P4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JO9lvWDNH3z7cP/LnZ/NAZk4jnktr8vERQYCrrkS51dBnBDb0ttqcsj1KYhrJZvB4F
         yVBaXAlc6Nvl6hufmnXl4FJ5ljo+qr/pKo5zXIY23gJsDFPH1wl6OtLvxa0r/v3LcUzg
         QeDvfzB71g0e+N4Hadh0r/hr3eObO4IaMC8Os=
Date: Mon, 28 Feb 2011 16:56:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, stable@kernel.org,
        dk@in-telegence.net
Subject: Re: [PATCH] blk-thrttole: Do not use kblockd workqueue for throtl
 work
Message-ID: <20110228155612.GA18401@htj.dyndns.org>
References: <1298908305-12032-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298908305-12032-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:51:45AM -0500, Vivek Goyal wrote:
> o Dominik Klein reported a system hang issue while doing some blkio throttling
>   testing.
> 
>   https://lkml.org/lkml/2011/2/24/173
> 
> o Some tracing revealed that CFQ was not dispatching any more jobs as queue
>   unplug was not happening. And queue unplug was not happening because unplug
>   work was not being called as there was one throttling work on same cpu
>   which as not finished yet. And throttling work had not finished as it
>   was tyring to dispatch a bio to CFQ but all the request descriptors were
>   consume to it was put to sleep.
> 
> o So basically it is a cyclic dependecny between CFQ unplug work and throtl
>   dispatch work. Tejun suggested that use separate workqueue for such cases.
> 
> o This patch uses a separate workqueue for throttle related work and does not
>   rely on kblockd workqueue anymore.
> 
> Cc: stable@kernel.org
> Reported-by: Dominik Klein <dk@in-telegence.net>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
