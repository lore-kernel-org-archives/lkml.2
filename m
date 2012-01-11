Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab2AKWLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:11:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab2AKWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:11:43 -0500
Date: Thu, 12 Jan 2012 07:11:37 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH 1/2] KVM: Exception during emulation decode should
 propagate
Message-Id: <20120112071137.303628cea69b79868956d860@gmail.com>
In-Reply-To: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 18:53:30 +0200
Nadav Amit <namit@cs.technion.ac.il> wrote:

> An exception might occur during decode (e.g., #PF during fetch).
> Currently, the exception is ignored and emulation is performed.

When I cleaned up insn_fetch(), I thought that fetching the instruction
which is being executed by the guest cannot cause #PF.

The possibility that a meaningless userspace might similtaneously unmap
the page, noted by Avi IIRC, was ignored intentionally, so we just fail
in such a case.

Did you see any real problem?

	Takuya


> Instead, emulation should be skipped and the fault should be injected.
> Skipping instruction should report a failure in this case.
