Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0DWN5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:57:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab0DWN5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:57:35 -0400
Subject: Re: [PATCH 7/8] KVM: x86: Allow marking an exception as reinjected
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-8-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:57:32 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <46B1F208-76A4-4C2F-9AE7-789264AB2D4B@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-8-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 12:33, Joerg Roedel wrote:

> This patch adds logic to kvm/x86 which allows to mark an
> injected exception as reinjected. This allows to remove an
> ugly hack from svm_complete_interrupts that prevented
> exceptions from being reinjected at all in the nested case.
> The hack was necessary because an reinjected exception into
> the nested guest could cause a nested vmexit emulation. But
> reinjected exceptions must not intercept. The downside of
> the hack is that a exception that in injected could get
> lost.
> This patch fixes the problem and puts the code for it into
> generic x86 files because. Nested-VMX will likely have the
> same problem and could reuse the code.

So we always handle the reinjection from KVM code? Shouldn't the l1 hypervisor do this?

Alex

