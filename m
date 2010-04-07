Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab0DGBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:23:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48723 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0DGBXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:23:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 7 Apr 2010 10:19:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/14] Add /sys trigger for per-node memory compaction
Message-Id: <20100407101913.58d1855b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100406175601.b131e9d2.akpm@linux-foundation.org>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-11-git-send-email-mel@csn.ul.ie>
	<20100406170559.52093bd5.akpm@linux-foundation.org>
	<20100407093148.d5d1c42f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100406175601.b131e9d2.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 17:56:01 -0400
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 Apr 2010 09:31:48 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > A cgroup which controls placement of memory is cpuset.
> 
> err, yes, that.
> 
> > One idea is per cpuset. But per-node seems ok.
> 
> Which is superior?
> 
> Which maps best onto the way systems are used (and onto ways in which
> we _intend_ that systems be used)?
> 

node has hugepage interface now.

[root@bluextal qemu-kvm-0.12.3]# ls /sys/devices/system/node/node0/hugepages/
hugepages-2048kB

So, per-node knob is straightforward. 

> Is the physical node really the best unit-of-administration?  And is
> direct access to physical nodes the best means by which admins will
> manage things?

In these days, we tend to use "setup tool" for using cpuset, etc.
(as libcgroup.)

Considering control by userland-support-soft, I think pernode is not bad.
And per-cpuset requires users to mount cpuset.
(Now, most of my customer doesn't use cpuset.)


Thanks,
-Kame


