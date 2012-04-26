Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2DZVxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab2DZVxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:53:03 -0400
Date: Thu, 26 Apr 2012 17:52:57 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4-rc4 oom killer out of control.
Message-ID: <20120426215257.GA12908@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120426193551.GA24968@redhat.com>
 <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:40:48PM -0700, David Rientjes wrote:
 > On Thu, 26 Apr 2012, Dave Jones wrote:
 > 
 > > On a test machine that was running my system call fuzzer, I just saw
 > > the oom killer take out everything but the process that was doing all
 > > the memory exhausting.
 > > 
 > 
 > Would it be possible to try the below patch?  It should kill the thread 
 > using the most memory (which happens to only be a couple more megabytes on 
 > your system), but it might just delay the inevitable since the system is 
 > still in a pretty bad state.
 > 
 > KOSAKI-san suggested doing this before and I think it's the best direction 
 > to go in anyway.

Sure, I'll give it a shot when I reboot.

However, see my follow-up message. I think there are two bugs here.
1) The over-aggressive oom-killer, and 2) ksmd going mental.

/sys/kernel/mm/ksm/full_scans is increasing constantly

full_scans: 146370
pages_shared: 1
pages_sharing: 4
pages_to_scan: 1250
pages_unshared: 867
pages_volatile: 1
run: 1
sleep_millisecs: 20

everything in /sys/kernel/mm/hugepages/hugepages-2048kB, is 0.

/sys/kernel/mm/transparent_hugepage/khugepaged:
alloc_sleep_millisecs  60000
defrag  1
full_scans  15
max_ptes_none 511 
pages_collapsed  6
pages_to_scan  4096
scan_sleep_millisecs 10000


	Dave

