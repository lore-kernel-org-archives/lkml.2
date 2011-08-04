Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1HDQaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:30:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1HDQ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:29:59 -0400
Date: Thu, 4 Aug 2011 13:29:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: kvm@vger.kernel.org, kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org,
        avi@redhat.com, riel@redhat.com, glommer@redhat.com,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com
Subject: Re: [RFC PATCH 0/3] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20110804162902.GA27692@amt.cnet>
References: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 10:24:58AM -0400, Eric B Munson wrote:
> This set is just a rough first pass at avoiding soft lockup warnings when a host
> pauses the execution of a guest.  A flag is set by the host in the shared page
> used for the pvclock when the host goes to stop the guest.  When the guest
> resumes and detects a soft lockup, this flag is checked and cleared and the soft
> lockup message is skipped.
> 
> This currently breaks the build for non-x86 architectures but part of what I am
> looking for here is how to go about adding the function stubs for everything
> else.

To fix this, you can save/restore the offset added to kvmclock on
vmstop/vmstart. See hw/kvmclock.c in the qemu source tree.

