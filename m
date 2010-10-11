Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0JKNxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab0JKNxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:53:19 -0400
Subject: Re: [PATCH wq#for-next] workqueue: add and use WQ_MEM_RECLAIM flag
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Dave Chinner <david@fromorbit.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <4CB30F9A.9030809@kernel.org>
References: <4CB30F9A.9030809@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Oct 2010 14:59:04 +0100
Message-ID: <1286805544.2753.102.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-10-11 at 15:22 +0200, Tejun Heo wrote:
> Add WQ_MEM_RECLAIM flag which currently maps to WQ_RESCUER, mark
> WQ_RESCUER as internal and replace all external WQ_RESCUER usages to
> WQ_MEM_RECLAIM.
> 
> This makes the API users express the intent of the workqueue instead
> of indicating the internal mechanism used to guarantee forward
> progress.  This is also to make it cleaner to add more semantics to
> WQ_MEM_RECLAIM.  For example, if deemed necessary, memory reclaim
> workqueues can be made highpri.
> 
> This patch doesn't introduce any functional change.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> ---
> WQ_RESCUER is a bit too specific to be directly used by workqueue
> users.  Let's clean it up before the usage is widespread.  If nobody
> objects, I'd like to route this through the workqueue tree.  Also, as
> WQ_RESCUER isn't removed, this won't break anything from other trees
> and those can be updated later.
> 
> Thanks.
> 
Looks good to me, but we'll need to bear in mind that this patch is
already queued for the next merge window:
http://git.kernel.org/?p=linux/kernel/git/steve/gfs2-2.6-nmw.git;a=commitdiff;h=9fa0ea9f26f64fbfc3dfd51d1dc2c230b65ffb19

so we'll have to figure out how best to merge when the time comes,

Steve


