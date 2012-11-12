Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2KLOzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:55:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62819 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2KLOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:55:11 -0500
Date: Mon, 12 Nov 2012 15:55:05 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Message-ID: <20121112145505.GC24433@rric.localhost>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
 <20121110115027.GC2777@rric.localhost>
 <20121111184426.GA5415@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121111184426.GA5415@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On 11.11.12 12:44:26, Jacob Shin wrote:
> Because
> in an upcoming processor family, there is no core performance counter
> extensions, but we do have northbridge performance counters. Meaning
> the counter address base would be c0010000 and northbridge counters
> live in c0010240, being 0x240 apart, we could make counter masks work
> but that testng awful alot of 0's for every address offset calculation
> .

I agree with you that my imlementation of counter masks does not fit
perfectly for this reason and also since it requires too much changes
in generic code (for_each_generic_counter()) which Peter did not like
either. So it is ok to me to replace your solution with the patch that
implenents counter bitmasks.

-Robert
