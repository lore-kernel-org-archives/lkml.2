Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1K2SWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:22:39 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:16134
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab1K2SWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:22:37 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVFPPK-01-MX1-02
X-M-MSG: 
Date: Tue, 29 Nov 2011 19:22:31 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111129182231.GZ15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110930134040.GA5575@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.11 09:40:40, Stephane Eranian wrote:
> @@ -385,36 +1433,69 @@ static int perf_header__adds_write(struct perf_header *header,
>         sec_start = header->data_offset + header->data_size;
>         lseek(fd, sec_start + sec_size, SEEK_SET);
> 
> -       if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
> -               struct perf_file_section *trace_sec;
> -
> -               trace_sec = &feat_sec[idx++];
> +       err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
> +       if (err)
> +               goto out_free;
> 
> -               /* Write trace info */
> -               trace_sec->offset = lseek(fd, 0, SEEK_CUR);
> -               read_tracing_data(fd, &evlist->entries);
> -               trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
> +       err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
> +       if (err) {
> +               perf_header__clear_feat(header, HEADER_BUILD_ID);
> +               goto out_free;
>         }

Stephane,

I am just looking at the code and got a question:

Is there a reason for the different error handling for
HEADER_TRACE_INFO and HEADER_BUILD_ID? All other types simply disable
the feature and go on without returning an error (goto out_free).

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

