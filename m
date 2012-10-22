Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2JVPkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:40:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:33955 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2JVPjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,630,1344236400"; 
   d="scan'208";a="230683766"
Date: Mon, 22 Oct 2012 08:39:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
Message-ID: <20121022153952.GM2095@tassilo.jf.intel.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
 <1350912052-10066-2-git-send-email-eranian@google.com>
 <20121022135358.GJ2095@tassilo.jf.intel.com>
 <CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But maybe you're talking about a generic event exports in
> /sys/device/cpu/events.
> But why would I expose prec_dist there. And under what name?

I already exposed it in the Haswell patchkit (instructions-p)

I also exposed precise there so that some events can be forced PEBS

If you want to expose it on Sandy Bridge too you need to add the 
event to the user tool grammar, like I did for precise.

Then user can just use

perf record -e instructions-p ...

and the kernel does automagically the right thing.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
