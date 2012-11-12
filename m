Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2KLOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:36:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51461 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KLOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:36:40 -0500
Date: Mon, 12 Nov 2012 15:36:30 +0100
From: Robert Richter <rric@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Message-ID: <20121112143630.GB24433@rric.localhost>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
 <20121110115027.GC2777@rric.localhost>
 <CABPqkBSdEsKwzni2VQcedV9tOFWWCVVV4WhmkWHRp6nFTo9wDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSdEsKwzni2VQcedV9tOFWWCVVV4WhmkWHRp6nFTo9wDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.12 19:17:07, Stephane Eranian wrote:
> On Sat, Nov 10, 2012 at 12:50 PM, Robert Richter <rric@kernel.org> wrote:
> > Peter's main concerns were that my patch set is not in the
> > Intel-uncore style. I started reworking this but was not able to
> > finish my work. This concerns still exist.
> >
> That was my concern too. I don't recall exactly why it could not
> be totally disconnected from the core PMU. I think hardware-wise,
> it was possible. Could you refresh my memory?

Current implementation only allows the use of a single x86 pmu.
Multiple instances of x86 pmus in a system like an additional pmu for
nb counters requires a complete rework. You need to remove global
variables and extend function interfaces by arguments pointing to a
struct x86_pmu. All this without adding overhead (e.g. pointer
chasing) compared to the existing code.

This is also the reason why the intel-uncore implemenation is
basically a copy-and-paste of generic x86 pmu code plus uncore
specific changes.

Avoiding code cuplication and a complex rework were the reasons for
simply extending the family 10h implementation to also support family
15h nb counters. This seemed to me the best approach that time.

-Robert
