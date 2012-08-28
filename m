Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2H1OZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:25:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2H1OZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:25:33 -0400
Message-ID: <503CD4D6.40503@redhat.com>
Date: Tue, 28 Aug 2012 16:25:26 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] virtio-scsi: allocate target pointers in a separate
 memory block
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-4-git-send-email-pbonzini@redhat.com> <503CD097.2020900@gmail.com>
In-Reply-To: <503CD097.2020900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/08/2012 16:07, Sasha Levin ha scritto:
>> > -	num_targets = sh->max_id;
>> > -	for (i = 0; i < num_targets; i++) {
>> > -		kfree(vscsi->tgt[i]);
>> > -		vscsi->tgt[i] = NULL;
>> > +	if (vscsi->tgt) {
>> > +		num_targets = sh->max_id;
>> > +		for (i = 0; i < num_targets; i++) {
>> > +			kfree(vscsi->tgt[i]);
> Since we now kmalloc() the vscsi->tgt array, it doesn't get zeroed anymore.
> 
> This means that if for example, num_targets=3, and the second
> virtscsi_alloc_tgt() in virtscsi_init() failed, we're going to kfree() garbage here.

Right, changed to kzalloc.

Paolo
