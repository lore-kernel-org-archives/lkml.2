Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0CQQ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:28:51 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:57274 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0CQQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:28:47 -0400
Date: Wed, 17 Mar 2010 16:27:12 +0000
From: Chris Webb <chris@arachsys.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100317162711.GK1997@arachsys.com>
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
 <20100315202353.GJ3840@arachsys.com>
 <4B9EC60A.2070101@codemonkey.ws>
 <20100317151409.GY31148@arachsys.com>
 <4BA0FB83.1010502@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA0FB83.1010502@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> writes:

> On 03/17/2010 10:14 AM, Chris Webb wrote:
> >   (c) installations that are already broken and lose data with a physical
> >       drive with a write-cache can lose much more in this case because the
> >       write cache is much bigger?
> 
> This is the closest to the most accurate.
> 
> It basically boils down to this: most enterprises use a disks with
> battery backed write caches.  Having the host act as a giant write
> cache means that you can lose data.
> 
> I agree that a well behaved file system will not become corrupt, but
> my contention is that for many types of applications, data lose ==
> corruption and not all file systems are well behaved.  And it's
> certainly valid to argue about whether common filesystems are
> "broken" but from a purely pragmatic perspective, this is going to
> be the case.

Okay. What I was driving at in describing these systems as 'already broken'
is that they will already lose data (in this sense) if they're run on bare
metal with normal commodity SATA disks with their 32MB write caches on. That
configuration surely describes the vast majority of PC-class desktops and
servers!

If I understand correctly, your point here is that the small cache on a real
SATA drive gives a relatively small time window for data loss, whereas the
worry with cache=writeback is that the host page cache can be gigabytes, so
the time window for unsynced data to be lost is potentially enormous.

Isn't the fix for that just forcing periodic sync on the host to bound-above
the time window for unsynced data loss in the guest?

Cheers,

Chris.
