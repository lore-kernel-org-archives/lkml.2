Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2B0RjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:39:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab2B0RjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:39:19 -0500
Date: Mon, 27 Feb 2012 19:39:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        peterz@infradead.org, mingo@elte.hu, joro@8bytes.org,
        joerg.roedel@amd.com
Subject: Re: [PATCH] perf tools: fix guest mode monitoring on AMD
Message-ID: <20120227173900.GE22220@redhat.com>
References: <20120227173351.GA6945@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227173351.GA6945@quad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:33:51PM +0100, Stephane Eranian wrote:
> Commit:
> 
> 1aed267 perf kvm: Do guest-only counting by default
>  
> introduced a bug on AMD systems whereby simple commands:
> 
> $ perf stat ls
> Performance counter stats for 'ls':
>                  0 cycles                    #    0.000 GHz                    
>        0.003704596 seconds time elapsed
> 
> would not count anything anymore. Same results for perf record.
> 
> I tracked it down to guest mode exclusion being enabled
> by default leading to attr->exclude_guest = 1. When
> not operating under any sort of virtualization, this
> causes the PMU not to count anything.
CCing Joerg. I think he fixed this or similar problem recently.

> 
> The fix disables guest exclusion by default.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 8109a90..c1017b3 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -6,7 +6,7 @@
>   * XXX We need to find a better place for these things...
>   */
>  bool perf_host  = true;
> -bool perf_guest = false;
> +bool perf_guest = true;
>  
>  void event_attr_init(struct perf_event_attr *attr)
>  {

--
			Gleb.
