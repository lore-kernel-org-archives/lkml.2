Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab0DBKee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:34:34 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:38011 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab0DBKe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NO57+G3zondFO5e8/nBRMjxH33N1vKwb8iFp4YE0eNGpSVSRSso6bA7gV//DWnzRiy
         3DAYFD/4GOn0k4697ItkJ+ItaC9ZQ7OMHlLzh5rQlXhYe1tnqXHhQjEny3Dno8zXhfp3
         HIZkyA0Hpiv2oai/QpHIHdJ2LnhD3bvy15R34=
MIME-Version: 1.0
In-Reply-To: <4BB35A53.5000003@oracle.com>
References: <6278d2221003291136p6481fe8emfb039403343c082@mail.gmail.com>
	 <20100329190307.GJ30031@ZenIV.linux.org.uk>
	 <1269897740.15895.82.camel@localhost.localdomain>
	 <w2s6278d2221003310420xd36fa9ey92b781fb9f4d1a10@mail.gmail.com>
	 <4BB35A53.5000003@oracle.com>
Date: Fri, 2 Apr 2010 11:34:26 +0100
Message-ID: <y2p6278d2221004020334lfb6513e9w776e33435888f686@mail.gmail.com>
Subject: Re: [2.6.34-rc2 NFS4 oops] open error path failure...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-nfs@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 3:21 PM, Chuck Lever <chuck.lever@oracle.com> wrote:
> On 03/31/2010 07:20 AM, Daniel J Blueman wrote:
>>
>> Talking of expensive, I see latencytop show>16000ms latency for
>> writing pages when I have a workload that does large buffered I/O to
>> an otherwise uncongested server. The gigabit network is saturated, and
>> reads often stall for 1000-4000ms (!). Client has the default 16 TCP
>> request slots, and server has 8 nfsds - the server is far from disk or
>> processor-saturated. I'll see if there is any useful debugging I can
>> get about this.
>
> That latency is pretty much guaranteed to be due to a long RPC backlog queue
> on the client.  Bumping the size of the slot table to 128 and increasing the
> number of NFSD threads may help.

Increasing these values did help quite a bit, though I was still
seeing 5000-8000ms at nfs_wait_bit_uninterruptible()  [1] and close().
Then again, I also was seeing 'Scheduler waiting for cpu' taking up to
3000ms! I suspect processor throttling, due to exceeding thermal
limits.

Thanks,
  Daniel

--- [1]

nfs_wait_bit_uninterruptible
nfs_wait_on_request
nfs_wait_in_requests_locked
nfs_sync_mapping_wait
nfs_write_mapping
nfs_wb_nocommit
nfs_getattr
vfs_getattr
vfs_fstat
sys_newfstat
system_call_fastpath
-- 
Daniel J Blueman
