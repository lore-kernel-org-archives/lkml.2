Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0ITDxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 23:53:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34119 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0ITDxr (ORCPT
	<rfc822;groupwise-KNikanth@novell.com:0:0>);
	Sun, 19 Sep 2010 23:53:47 -0400
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2010 23:53:47 EDT
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Richard Guenther <rguenther@suse.de>
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are reported clean in smaps
Date: Sun, 19 Sep 2010 23:07:09 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com> <20100915140911.GC4383@balbir.in.ibm.com> <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
In-Reply-To: <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
MIME-Version: 1.0
Message-Id: <201009192307.09309.knikanth@suse.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010 19:44:17 Richard Guenther wrote:
> On Wed, 15 Sep 2010, Balbir Singh wrote:
> > * Nikanth Karthikesan <knikanth@suse.de> [2010-09-15 12:01:11]:
> > > How? Current smaps information without this patch provides incorrect
> > > information. Just because a private dirty page became part of swap
> > > cache, it shown as clean and backed by a file. If it is shown as clean
> > > and backed by swap then it is fine.
> >
> > How is GDB using this information?
> 
> GDB counts the number of dirty and swapped pages in a private mapping and
> based on that decides whether it needs to dump it to a core file or not.
> If there are no dirty or swapped pages gdb assumes it can reconstruct
> the mapping from the original backing file.  This way for example
> shared libraries do not end up in the core file.
> 

Well, may be /proc/pid/pagemap + /proc/kpageflags is enough for this! One can 
get the pageflags using these interfaces. See Documentation/vm/pagemap.txt for 
the explanation on how to do it. There is also a sample program that prints 
page flags using this interface in Documentation/vm/page-types.c.

It is bad that /proc/pid/pagemap is never mentioned in 
Documentation/filesystems/proc.txt. I will send a patch to rectify this.

Thanks
Nikanth
