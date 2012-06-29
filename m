Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2F2Dfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:35:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:25732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab2F2Dfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159511086"
Date: Thu, 28 Jun 2012 20:35:46 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
Message-ID: <20120629033546.GV4152@tassilo.jf.intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
 <1340899974.28750.66.camel@twins>
 <20120628182030.GR4152@tassilo.jf.intel.com>
 <1340916697.28750.91.camel@twins>
 <20120629093253.3e99ca0e@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629093253.3e99ca0e@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, that number scared me too when I first saw it, as the time will make
> the script totally useless. Then after migrating to the RAM based database
> file, the database handling time could be cut down to 1 second.

The problem is just that sqlite does a fdatasync for every insert.
Just need to figure out how to tell it to stop doing that.

Shouldn't be too hard ...

But yes /dev/shm should work well enough for now.

> 
> I guess the sqlite itself realize the shortcoming too, it also provide a
> native way to use in-memory database by specifying ":memory":
> 	con = sqlite3.connect(":memory:")

I think it's better to have a file on disk, then you can easily query
more properties just from the command line.

I can see all kinds of interesting data mining on the events
to be enabled by this. They have all the register values and various
other information.

For example if you look for string operations you could do
a histogram over the ECX values and so do a histogram of
memcpy/memset sizes. 

[Would be easier if perf could pass in the assembler opcode,
but could be done without)

Or when sampling spinlocks look at the addresses.
Or lots of other things people could imagine.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
