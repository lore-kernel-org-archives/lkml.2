Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab2LVQiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:38:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2LVQiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:38:03 -0500
Date: Sat, 22 Dec 2012 17:38:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 6/6] uretprobes: register() and unregister()
	implementation
Message-ID: <20121222163810.GF18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-7-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-7-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
> +int uretprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
> +{
> +	return __uprobe_register(inode, offset, uc, true);
> +}
> ...
> +
> +void uretprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
> +{
> +	struct uprobe *uprobe;
> +
> +	uprobe = find_uprobe(inode, offset);
> +	if (!uprobe)
> +		return;
> +
> +	down_write(&uprobe->register_rwsem);
> +	__uprobe_unregister(uprobe, uc, true);
> +	up_write(&uprobe->register_rwsem);
> +
>  	put_uprobe(uprobe);
>  }

See my reply to 3/6. So far I think that we do not need
uretprobe_register/unregister at all.

Oleg.

