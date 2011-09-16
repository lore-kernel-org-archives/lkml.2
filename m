Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1IPO1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:27:49 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50601 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1IPO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:27:47 -0400
Date: Fri, 16 Sep 2011 11:27:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] perf: Support setting the disassembler style
Message-ID: <20110916142736.GA15331@ghostprotocols.net>
References: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
 <1316122302-24306-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316122302-24306-2-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 15, 2011 at 02:31:41PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add -M option to report/annotate to pass directly to objdump.
> This allows to use -M intel for intel style disassembler syntax,
> which is useful for people who are very used to the Intel syntax.
 
>  linkperf:perf-record[1], linkperf:perf-report[1]
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 04253c0..0407c8c 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -134,6 +134,9 @@ OPTIONS
>  	CPUs are specified with -: 0-2. Default is to report samples on all
>  	CPUs.
>  
> +-m::
> +--disassembler-style=:: Set disassembler style for objdump.
> +

s/-m/-M/g

And adjusted it to cope with what is in perf/core, namely:

https://github.com/acmel/linux/commit/3e6a2a7f3b9d0e521bb3284573b696d0cbe1952c

<quote>
perf annotate: Make output more readable
This patch adds two new options to perf annotate:
	- --no-asm-raw : Do not display raw instruction encodings
	- --no-source  : Do not interleave source code with assembly
	  code

We believe those options make the output of annotate more readable.
</>

- Arnaldo
