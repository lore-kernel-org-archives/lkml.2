Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2JWMbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:31:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab2JWMba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:31:30 -0400
Message-ID: <1350995474.13456.12.camel@twins>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 14:31:14 +0200
In-Reply-To: <1350602382-12771-6-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-6-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> +               raw.size = x86_pmu.pebs_record_size;
> +               raw.data = __pebs;
> +               data.raw = &raw;
> +       } 

The Changelog babbles about registers, yet you export the entire record.

There's the PERF_SAMPLE_REGS thing which has been pointed out to you,
but you fail to include this in your arguments.

Also, there's an alignment issue there, the raw.data is 32bit offset,
the record is u64 aligned, leaving the output stream offset, wrecking
things.

And as with any ABI extension, it should come with useful userspace to
make use of it.

I'll hold off on this one for now.
