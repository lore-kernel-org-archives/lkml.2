Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2BGHDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:03:49 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51273 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2BGHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:03:48 -0500
Message-ID: <4F30CCA6.4040001@linux.vnet.ibm.com>
Date: Tue, 07 Feb 2012 12:33:02 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-17-git-send-email-eranian@google.com> <20120206182208.GH6367@infradead.org>
In-Reply-To: <20120206182208.GH6367@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020707-2000-0000-0000-00000653202B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 February 2012 11:52 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 02, 2012 at 01:54:46PM +0100, Stephane Eranian escreveu:
>> This patch allows perf to process perf.data files generated
>> using an ABI that has a different perf_event_attr struct size, i.e.,
>> a different ABI version.
>>
>> The perf_event_attr can be extended, yet perf needs to cope with
>> older perf.data files. Similarly, perf must be able to cope with
>> a perf.data file which is using a newer version of the ABI than
>> what it knows about.
>>
>> This patch adds read_attr(), a routine that reads a perf_event_attr
>> struct from a file incrementally based on its advertised size. If
>> the on-file struct is smaller than what perf knows, then the extra
>> fields are zeroed. If the on-file struct is bigger, then perf only
>> uses what it knows about, the rest is skipped.
> 
> Anshuman, can I have your Acked-by or Reviewed-by since you spotted
> problems in this and your suggestions were taken into account? Is this
> OK now?
> 

(1) PERF_SAMPLE_BRANCH_HV and related privilege level problems has been fixed. 
    Verified various combinations of <branch_type>,[u,k,hv] <event>:[u,k,h].
    Works well in all privilege level permutations.

(2) As Peter has mentioned 'has_branch_smpl()' bug in the ARM code would be taken
    care.

(3) 'ref_size' problem in try_all_pipe_abis() has been fixed. All the patches 
    independently compile successfully.

(4) Went through the entire patchset, looks good to me. 

Acked-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Tested-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group

