Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab0DVUS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:18:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49043 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab0DVUSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:18:22 -0400
MIME-Version: 1.0
Message-ID: <b1036777-129b-4531-a730-1e9e5a87cea9@default>
Date: Thu, 22 Apr 2010 13:15:50 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
 <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default
 4BD07594.9080905@redhat.com>
In-Reply-To: <4BD07594.9080905@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BD0AEF0.006E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Synchronous is required, but likely could be simulated by ensuring
> all
> > coherency (and concurrency) requirements are met by some intermediate
> > "buffering driver" -- at the cost of an extra page copy into a buffer
> > and overhead of tracking the handles (poolid/inode/index) of pages in
> > the buffer that are "in flight".  This is an approach we are
> considering
> > to implement an SSD backend, but hasn't been tested yet so, ahem, the
> > proof will be in the put'ing. ;-)
> 
> Much easier to simulate an asynchronous API with a synchronous backend.

Indeed.  But an asynchronous API is not appropriate for frontswap
(or cleancache).  The reason the hooks are so simple is because they
are assumed to be synchronous so that the page can be immediately
freed/reused.
 
> Well, copying memory so you can use a zero-copy dma engine is
> counterproductive.

Yes, but for something like an SSD where copying can be used to
build up a full 64K write, the cost of copying memory may not be
counterproductive.
