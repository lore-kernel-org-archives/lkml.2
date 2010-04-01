Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0DAUVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:21:06 -0400
Received: from 8bytes.org ([88.198.83.132]:60648 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775Ab0DAUVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:21:01 -0400
Date: Thu, 1 Apr 2010 22:21:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401202100.GL24846@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <201004010906.47321.pugs@lyon-about.com> <4BB4C591.8000102@redhat.com> <201004011224.45336.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011224.45336.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:24:45PM -0700, Tom Lyon wrote:

> For my purposes, collapsing all the MSI-Xs into one MSI-look-alike is fine, 
> because I'd be using MSI anyways if I could. The weird Intel 82599 VF only 
> supports MSI-X.

For KVM this is not fine. The device should look in the guest as it
looks in the host. Some devices might only support MSI-X and thus the
drivers for it only search for MSI-X and get confused when they only
find MSI.

> So one big question is - do we expand the whole UIO framework for KVM 
> requirements, or do we split off either KVM or non-VM into a separate driver?
> Hans or Greg - care to opine?

We should definitly work towards a single implementation. The KVM device
passthrough requirements are not very different from that of userspace
device access.

	Joerg

