Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2KLPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:12:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab2KLPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:12:21 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v3 04/10] scsi: allocate scsi_cmnd-s from the device's local numa node
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
	<1352488687-19935-5-git-send-email-jmoyer@redhat.com>
	<509E178B.6090601@acm.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 12 Nov 2012 09:25:05 -0500
In-Reply-To: <509E178B.6090601@acm.org> (Bart Van Assche's message of "Sat, 10
	Nov 2012 09:59:55 +0100")
Message-ID: <x49zk2mkif2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/09/12 20:18, Jeff Moyer wrote:
>> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
>> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
>> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
>> +				    node);
>
> Hello Jeff,
>
> Is it necessary to add __GFP_ZERO here ? And if so, why ?

Hi, Bart,

The code used to do zeroing, so I just kept that aspect the same.  There
is no kmem_cache_zalloc_node, and it didn't seem worth adding one.

Cheers,
Jeff
