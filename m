Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab0KASqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:46:32 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:17772 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0KASq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:46:29 -0400
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 14:46:28 EDT
Subject: Re: Regression, bisected: sqlite locking failure on nfs
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20101101181938.GA3875@elliptictech.com>
Date: Mon, 1 Nov 2010 14:30:03 -0400
Cc: LKML Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <187AEE96-9231-4899-9D65-A444503D2758@oracle.com>
References: <20101101175854.GA3550@elliptictech.com> <D68536EB-6BE9-4DE4-B325-39FEF747092E@oracle.com> <20101101181938.GA3875@elliptictech.com>
To: Nick Bowler <nbowler@elliptictech.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2010, at 2:19 PM, Nick Bowler wrote:

> On 2010-11-01 14:07 -0400, Chuck Lever wrote:
>> On Nov 1, 2010, at 1:58 PM, Nick Bowler wrote:
>>> After installing 2.6.37-rc1, attempting to use sqlite in any capacity on
>>> NFS gives a locking error:
>>> 
>>> % echo 'select * from blah;' | sqlite3 blah.sqlite
>>> Error: near line 1: database is locked
>>> 
>>> % echo 'create table blargh(INT);' | sqlite3 blargh.sqlite
>>> Error: near line 1: database is locked
>>> 
>>> The result is that a lot of high-profile applications which make use of
>>> sqlite fail mysteriously.  Bisection reveals the following, and
>>> reverting the implicated commit solves the issue:
>> 
>> Nick, thanks for the report.  Is 2.6.37-rc1 running on your clients or
>> on your server?
> 
> Sorry for not being clear: the client is running 2.6.37-rc1.   The
> server is running RHEL 5.5.
> 
>> Does anything interesting appear in the kernel log when your test case
>> fails?
> 
> There are no unusual messages on the client... but I just logged into
> the server and I see lots of messages of the following form:
> 
>  nfsd: request from insecure port (192.168.8.199:35766)!
>  nfsd: request from insecure port (192.168.8.199:35766)!
>  nfsd: request from insecure port (192.168.8.199:35766)!
>  nfsd: request from insecure port (192.168.8.199:35766)!
>  nfsd: request from insecure port (192.168.8.199:35766)!
> 
> (192.168.8.199 is the address of the failing client).  I can only assume
> that these are a result of my recent issues, since I don't have access
> to the system log (with timestamps) on that machine.

That's the problem this patch is supposed to prevent.  I'll investigate further.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




