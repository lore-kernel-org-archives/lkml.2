Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2LRR1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:27:13 -0500
Received: from vm-emlprdomg-05.its.yale.edu ([130.132.50.168]:44931 "EHLO
	vm-emlprdomg-05.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081Ab2LRR1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:27:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: Andreas Voellmy <andreas.voellmy@yale.edu>
In-Reply-To: <4854E278-265E-433E-B55E-E60DA4C300F2@yale.edu>
Date: Tue, 18 Dec 2012 12:27:10 -0500
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "junchang.wang@yale.edu Wang" <junchang.wang@yale.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <4335C40C-5F4E-484F-8D4B-38D6A244259A@yale.edu>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net> <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu> <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu> <4F40C83D-1C29-4654-8B9C-9DBFB63BDC1D@yale.edu> <20121218020732.GA13396@dcvr.yhbt.net> <4854E278-265E-433E-B55E-E60DA4C300F2@yale.edu>
To: Eric Wong <normalperson@yhbt.net>
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-18_08:2012-12-18,2012-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1212180122
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, I simplified the test program a bit: I removed the loop that epoll_waits on the eventfd fd and reads from it (I also removed the epoll instance in that loop).  The bug still occurs with this removed. Now the bug is triggered simply by adding the call to eventfd_write after processing each request. 

I pushed the update to my github project for the test program.

-Andi

On Dec 17, 2012, at 9:35 PM, Andreas Voellmy <andreas.voellmy@yale.edu> wrote:

> 
> On Dec 17, 2012, at 9:07 PM, Eric Wong <normalperson@yhbt.net> wrote:
> 
>> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
>>> There were a couple of errors in the code when I posted my last
>>> message. I have fixed those. The epoll bug still occurs. 
>> 
>> Sorry I haven't gotten around to this.
>> 
>> Can you reproduce this with fewer cores? (I only have 4 at most).
> 
> I've been able to reproduce it on as few as 8 cores. I've never seen it occur with fewer than that.
> 
>> Have you tried the latest stable kernel version?
> 
> No, I've only tried 3.4.0.0.
> 
>> 
>> Can you reproduce this over TCP loopback, or only across two machines?
>> If the latter, it could also be a driver or firmware bug...
> 
> Yes, it also occurs when I run the http request generator on the same machine on the loopback interface.
> 
> -Andi

