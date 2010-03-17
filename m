Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0CQRss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:48:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0CQRsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:48:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VpsvRHHLHcTJDfYkRornrwTFUBa0PNULwpjLJa8A7H1pS0Y0hvnWIVC7vjzeh5RxG
	AALCv3IY/k2W06cuaCNrw==
MIME-Version: 1.0
In-Reply-To: <20100316164121.024e35d8.nishimura@mxp.nes.nec.co.jp>
References: <1268609202-15581-1-git-send-email-arighi@develer.com> 
	<1268609202-15581-3-git-send-email-arighi@develer.com> <20100316164121.024e35d8.nishimura@mxp.nes.nec.co.jp>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 17 Mar 2010 09:48:18 -0800
Message-ID: <49b004811003171048h5f27405oe6ea39a103bc4ee3@mail.gmail.com>
Subject: Re: [PATCH -mmotm 2/5] memcg: dirty memory documentation
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 11:41 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> On Mon, 15 Mar 2010 00:26:39 +0100, Andrea Righi <arighi@develer.com> wrote:
>> Document cgroup dirty memory interfaces and statistics.
>>
>> Signed-off-by: Andrea Righi <arighi@develer.com>
>> ---
>>  Documentation/cgroups/memory.txt |   36 ++++++++++++++++++++++++++++++++++++
>>  1 files changed, 36 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
>> index 49f86f3..38ca499 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
>> @@ -310,6 +310,11 @@ cache            - # of bytes of page cache memory.
>>  rss          - # of bytes of anonymous and swap cache memory.
>>  pgpgin               - # of pages paged in (equivalent to # of charging events).
>>  pgpgout              - # of pages paged out (equivalent to # of uncharging events).
>> +filedirty    - # of pages that are waiting to get written back to the disk.
>> +writeback    - # of pages that are actively being written back to the disk.
>> +writeback_tmp        - # of pages used by FUSE for temporary writeback buffers.
>> +nfs          - # of NFS pages sent to the server, but not yet committed to
>> +               the actual storage.

Should these new memory.stat counters (filedirty, etc) report byte
counts rather than page counts?  I am thinking that byte counters
would make reporting more obvious depending on how heterogeneous page
sizes are used. Byte counters would also agree with /proc/meminfo.
Within the kernel we could still maintain page counts.  The only
change would be to the reporting routine, mem_cgroup_get_local_stat(),
which would scale the page counts by PAGE_SIZE as it does for for
cache,rss,etc.

--
Greg
