Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2DTIKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:10:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2DTIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:09:51 -0400
Date: Fri, 20 Apr 2012 10:09:43 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: per-queue policy activation, take#2
Message-ID: <20120420080943.GG7505@kernel.dk>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13 2012, Tejun Heo wrote:
> Hello,
> 
> Upto now, blkcg assumed that all policies are active on all queues
> which simply isn't true - cfq policy is only applicable to queues
> which are using cfq as the elevator.  Also, for transition purposes,
> the current implementation clears all !root blkgs blkgs across
> elevator switch and policy [de]registration in racy manner.
> 
> This patchset implements per-queue policy activation.  Static policy
> ID is replaced with dynamic registration and each policy should be
> activated and deactivated explicitly on each queue.  On activation,
> the matching policy data are created on all existing blkgs.  On
> deactivation, the matching policy data are removed from all existing
> blkgs.  blkg printing skips blkg-policy combination which is disabled
> and trying to configure a policy on a blkg which doesn't have the
> policy enabled would return -EINVAL instead of creating an unused
> dummy configuration.
> 
> Changes from the last take[L] are
> 
> * 0001 to fix config dependent build error / warnings added.
> 
> * More comments added to 0006 as suggested by Vivek.
> 
> * 0007 added to avoid boot time bypass delays.
> 
> * 0009 made cfq_init_queue() return garbage after alloc failure if
>   !CONFIG_CFQ_GROUP_IOSCHED.  Fixed.
> 
> * 0011 which shoots down all blkgs if no policy is activated added.
>   Suggested by Vivek.
> 
>  0001-cfq-fix-build-breakage-warnings.patch
>  0002-blkcg-kill-blkio_list-and-replace-blkio_list_lock-wi.patch
>  0003-blkcg-use-pol-instead-of-plid-in-update_root_blkg_pd.patch
>  0004-blkcg-remove-static-policy-ID-enums.patch
>  0005-blkcg-make-blkg_conf_prep-take-pol-and-return-with-q.patch
>  0006-blkcg-make-sure-blkg_lookup-returns-NULL-if-q-is-byp.patch
>  0007-blkcg-make-request_queue-bypassing-on-allocation.patch
>  0008-blkcg-add-request_queue-root_blkg.patch
>  0009-blkcg-implement-per-queue-policy-activation.patch
>  0010-blkcg-drop-stuff-unused-after-per-queue-policy-activ.patch
>  0011-blkcg-shoot-down-blkgs-if-all-policies-are-deactivat.patch
> 
> This patchset is on top of the current block/for-3.5/core 5bc4afb1ec
> "blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros" and also available in
> the following git branch.

Applied. Even if we need a bit more churn on this one, we should get
things in gear and for-next updated at least.

-- 
Jens Axboe

