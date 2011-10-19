Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1JSN1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab1JSN1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:27:02 -0400
Date: Wed, 19 Oct 2011 09:26:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        ni@google.com
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111019132657.GA1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318998384-22525-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 09:26:16PM -0700, Tejun Heo wrote:
> blkio_policy_parse_and_set() calls blkio_check_dev_num() to check
> whether the given dev_t is valid.  blkio_check_dev_num() uses
> get_gendisk() for verification but never puts the returned genhd
> leaking the reference.
> 
> This patch collapses blkio_check_dev_num() into its caller and updates
> it such that the genhd is put before returning.

Hi Tejun,

What's the advantage of collapsing blkio_check_dev_num(). Why not put the
reference to gendisk in this function before returning either success or
failure.

Thanks
Vivek
