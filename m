Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2EXJVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:21:52 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53620 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2EXJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:21:51 -0400
Message-ID: <4FBDFDA6.5010304@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 14:51:42 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: eranian@google.com, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: perf record: why we used type casting of (uint64_t *) instead of
 int
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052323-5140-0000-0000-0000016E200A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephane,

Just wondering why we used the type casting of (uint64_t *) on a data 
which is defined as "int" in the structure of "perf_record_opts".

struct perf_record_opts {
        struct perf_target target;
        bool         call_graph;
        bool         group;
        bool         inherit_stat;
        bool         no_delay;
        bool         no_inherit;
        bool         no_samples;
        bool         pipe_output;
        bool         raw_samples;
        bool         sample_address;
        bool         sample_time;
        bool         sample_id_all_missing;
        bool         exclude_guest_missing;
        bool         period;
        unsigned int freq;
        unsigned int mmap_pages;
        unsigned int user_freq;
        int          branch_stack;
        u64          default_interval;
        u64          user_interval;
};

static int
parse_branch_stack(const struct option *opt, const char *str, int unset)
{
#define ONLY_PLM \
        (PERF_SAMPLE_BRANCH_USER        |\
         PERF_SAMPLE_BRANCH_KERNEL      |\
         PERF_SAMPLE_BRANCH_HV)

        uint64_t *mode = (uint64_t *)opt->value;
--
Regards
Anshuman Khandual

