Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2ILMdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2ILMdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:33:11 -0400
Message-ID: <505080F1.5090606@redhat.com>
Date: Wed, 12 Sep 2012 14:32:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        linux-iscsi@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: create an all-zero filter for scanners
References: <1347449024-26387-1-git-send-email-pbonzini@redhat.com> <1347449024-26387-3-git-send-email-pbonzini@redhat.com> <20120912133613.1255aa52@pyramind.ukuu.org.uk>
In-Reply-To: <20120912133613.1255aa52@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/09/2012 14:36, Alan Cox ha scritto:
>> >  	switch (sdev->type) {
>> > +	case TYPE_SCANNER:
>> > +		sdev->request_queue->cmd_filter =
>> > +			kzalloc(sizeof(struct blk_cmd_filter), GFP_KERNEL);
>> > +		/* fallthrough */
> Is that really desireable in the kzalloc failing case ?

Hmm, there is another kmalloc failure in the series that is worse than
this one, actually.

Paolo
