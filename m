Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab2ILOtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:49:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:53868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2ILOtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:49:22 -0400
Message-ID: <1347461351.15764.47.camel@twins>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 12 Sep 2012 16:49:11 +0200
In-Reply-To: <CABPqkBSCY1N8Zc9ZxRYmQykqg+hiukxW4ZRMWkp9wfaOSzgGrA@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-2-git-send-email-eranian@google.com>
	 <1347459984.15764.34.camel@twins>
	 <CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
	 <1347460719.15764.42.camel@twins>
	 <CABPqkBSCY1N8Zc9ZxRYmQykqg+hiukxW4ZRMWkp9wfaOSzgGrA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:46 +0200, Stephane Eranian wrote:

> I am fine with dropping this patch. I just found it odd there was a per-cpu
> data reference embedded deep into the call. I wanted things to be more
> explicit. I know it works without the proposed change.

Ah the reason its there is to make sure the base pointer is a valid base
pointer, this avoids an extra conditional in a number of places. Note
that it uses raw_get_cpu_var(), so it doesn't even actually know which
specific pointer goes in.


