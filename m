Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1LEVHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:07:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:38399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab1LEVHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:07:39 -0500
Message-ID: <1323119207.32012.33.camel@twins>
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 22:06:47 +0100
In-Reply-To: <1318595833-29984-2-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> @@ -455,6 +483,8 @@ enum perf_event_type {
>          *
>          *      { u32                   size;
>          *        char                  data[size];}&& PERF_SAMPLE_RAW
> +        *
> +        *      { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK 

		{ u64	nr;
		  { u64 from, to, flags } brstack[nr]; } && PERF_SAMPLE_BRANCH_STACK

Perhaps? It looks like you lost a line somewhere, even you curly braces
are unmatched in the correct way.
