Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2IEOqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:46:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab2IEOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:46:23 -0400
Message-ID: <504765B9.7010406@redhat.com>
Date: Wed, 05 Sep 2012 17:46:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
References: <20120821190800.24958.74812.stgit@bling.home> <20120821192903.24958.90138.stgit@bling.home>
In-Reply-To: <20120821192903.24958.90138.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 10:29 PM, Alex Williamson wrote:
> KVM_IRQFD currently uses the reserved KVM_USERSPACE_IRQ_SOURCE_ID
> which is also shared with userspace injection methods like
> KVM_IRQ_LINE.  This can cause a conflict if an irqfd triggers on
> a GSI asserted through KVM_IRQ_LINE.  Move irqfd to it's own
> reserved IRQ source ID.  Add a capability for userspace to test
> for this fix.

I don't think we need a cap, rather a backport if we identify real cases
where an edge gsi is shared among several devices.  Otherwise it is just
a theoretical bug before level irqfd is introduced.

-- 
error compiling committee.c: too many arguments to function
