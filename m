Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2BGB3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:29:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab2BGB3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:29:14 -0500
Message-ID: <4F307EFC.5010400@redhat.com>
Date: Tue, 07 Feb 2012 09:31:40 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, xiyou.wangcong@gmail.com,
        penberg@kernel.org, fengguang.wu@intel.com, cl@linux.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] move hugepage test examples to tools/testing/selftests/vm
References: <20120205081555.GA2249@darkstar.redhat.com> <20120206155340.b9075240.akpm@linux-foundation.org>
In-Reply-To: <20120206155340.b9075240.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 07:53 AM, Andrew Morton wrote:

> On Sun, 5 Feb 2012 16:15:55 +0800
> Dave Young <dyoung@redhat.com> wrote:
> 
>> hugepage-mmap.c, hugepage-shm.c and map_hugetlb.c in Documentation/vm are
>> simple pass/fail tests, It's better to promote them to tools/testing/selftests
>>
>> Thanks suggestion of Andrew Morton about this. They all need firstly setting up
>> proper nr_hugepages and hugepage-mmap need to mount hugetlbfs. So I add a shell
>> script run_test to do such work which will call the three test programs and
>> check the return value of them.
>>
>> Changes to original code including below:
>> a. add run_test script
>> b. return error when read_bytes mismatch with writed bytes.
>> c. coding style fixes: do not use assignment in if condition
>>
> 
> I think Frederic is doing away with tools/testing/selftests/run_tests
> in favour of a Makefile target?  ("make run_tests", for example).

>

> Until we see such a patch we cannot finalise your patch and if I apply
> your patch, his patch will need more work.  Not that this is rocket
> science ;)


Understand.

> 
>>
>> ...
>>
>> --- /dev/null
>> +++ b/tools/testing/selftests/vm/run_test
> 
> (We now have a "run_tests" and a "run_test".  The difference in naming
> is irritating)


Yes, I'm just refer to the breakpoints/Makefile which will make a target
breakpoints/run_test

> 
> Your vm/run_test file does quite a lot of work and we couldn't sensibly
> move all its functionality into Makefile, I expect.
> 
> So I think it's OK to retain a script for this, but I do think that we
> should think up a standardized way of invoking it from vm/Makefile, so
> the top-level Makefile in tools/testing/selftests can simply do "cd
> vm;make run_test", where the run_test target exists in all
> subdirectories.  The vm/Makefile run_test target can then call out to
> the script.


Frederic, do you have any idea about this?

> 
> Also, please do not assume that the script has the x bit set.  The x
> bit easily gets lost on kernel scripts (patch(1) can lose it) so it is
> safer to invoke the script via "/bin/sh script-name" or $SHELL or
> whatever.


Agree, and quilt can not keep the x bit as well, I have to use git to
create a executable shell script

> 
> Anyway, we should work with Frederic on sorting out some standard
> behavior before we can finalize this work, please.
> 


Fine, I can redo this after the standard behavior is out

-- 
Thanks
Dave
