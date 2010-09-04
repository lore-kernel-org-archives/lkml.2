Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0IDTcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 15:32:45 -0400
Received: from 8bytes.org ([88.198.83.132]:53602 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0IDTcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 15:32:43 -0400
Date: Sat, 4 Sep 2010 21:32:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alexander Graf <agraf@suse.de>
Cc: "Roedel, Joerg" <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation
Message-ID: <20100904193241.GB8162@8bytes.org>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com> <1283441387-7378-4-git-send-email-joerg.roedel@amd.com> <20100903122140.GG1964@amd.com> <1E478B32-8E9D-4041-B841-F64016FA5AB1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1E478B32-8E9D-4041-B841-F64016FA5AB1@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:29:11PM +0200, Alexander Graf wrote:
> Any reason we can't use the next_rip information here? A hypervisor
> could potentially do badness and put a prefix here, thus break all the
> logic, right?

Next_rip is not available on older hardware. Yes, this problem exists in
theory (as it does with rdmsr/wrmsr, cpuid, ... too). But a fix for this
on non-next-rip capable hardware would involve the instruction emulator
and kills all performance there. So we use this stupid and fast solution
here which works for all hypervisors I tested :-)

> (yes, I know, I wrote that code, but still ...)

When you wrote that code next_rip capable hardware was not available, so
don't worry :-)


	Joerg
