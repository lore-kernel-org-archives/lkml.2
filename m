Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2LVQfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:35:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2LVQfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:35:39 -0500
Date: Sat, 22 Dec 2012 17:35:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer
	handler
Message-ID: <20121222163545.GE18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-6-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-6-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
>  struct uprobe_consumer {
> -	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
> +	int (*handler)(struct uprobe_consumer *self, unsigned long bp_vaddr, struct pt_regs *regs);

It seems that we can do better...

Just change regs->ip before calling ->handler(). In both cases we are
going to change it again, so ->ip doesn't matter.

Initially I though we can't do this for uretprobes, but it seems we can.

I won't insist though.

Oleg.

