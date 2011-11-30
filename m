Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1K3PI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:08:58 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:18151
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1K3PIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:08:55 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVHBE7-01-0LZ-02
X-M-MSG: 
Date: Wed, 30 Nov 2011 16:08:29 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111130150829.GA15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
 <20111129182231.GZ15738@erda.amd.com>
 <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.11 10:35:24, Stephane Eranian wrote:
>         sec_start = header->data_offset + header->data_size;
>         lseek(fd, sec_start + sec_size, SEEK_SET);
> 
>         err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
>         if (err)
>                 goto out_free;
> 
>         err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
>         if (err) {
>                 perf_header__clear_feat(header, HEADER_BUILD_ID);
>                 goto out_free;
>         }
> 
> The 'clear_feat' is missing for TRACE_INFO, that's all. The question is:
> is case do_write_feat(trace_info) fails, is there still a way to parse the file
> correctly? If not, then perf should bail out, if yes, then we need to add the
> clear_feat(TRACE_INFO) in case of error.

The question is, if do_write_feat() fails for HEADER_TRACE_INFO or
HEADER_BUILD_ID then perf_header__adds_write() fails. A failure of any
other feature simple disables it by calling clear_feat(). I noticed
this asymmetry and wonder why?

Also, is there a reason why HEADER_TRACE_INFO starts with bit 1 instead
of bit 0. Is bit 0 reserved for some reason?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

