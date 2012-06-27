Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2F0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2F0PU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:20:26 -0400
Date: Wed, 27 Jun 2012 18:20:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 5/6] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120627152029.GB21393@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050952.23698.37235.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050952.23698.37235.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:10:08PM -0600, Alex Williamson wrote:
> +static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
> +{
> +	struct _eoifd *eoifd;
> +
> +	eoifd = container_of(notifier, struct _eoifd, notifier);
> +
> +	if (eoifd->source)
> +		kvm_set_irq(eoifd->kvm, eoifd->source->id,
> +			    eoifd->notifier.gsi, 0);

Let's add a comment here explaining why it's a safe thing
to do, which is, userspace will check status and reinject if
necessary.

-- 
MST
