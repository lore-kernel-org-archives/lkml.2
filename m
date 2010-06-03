Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab0FCCsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:48:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62573 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab0FCCsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:48:52 -0400
MIME-Version: 1.0
Message-ID: <57b44b18-0754-445d-af8c-9b3b1da6bd0e@default>
Date: Wed, 2 Jun 2010 19:47:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chris.mason@oracle.com,
       viro@zeniv.linux.org.uk, adilger@Sun.COM, tytso@mit.edu,
       mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: RE: [PATCH V2 2/7] Cleancache (was Transcendent Memory): core files
References: <20100528173550.GA12219@ca-server1.us.oracle.com>
 <20100602122900.6c893a6a.akpm@linux-foundation.org>
 <0be9e88e-7b0d-471d-8d49-6dc593dd43be@default 4C06F571.3050306@goop.org>
In-Reply-To: <4C06F571.3050306@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C0717FB.016D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It is intended that there be different flavours but only
> > one can be used in any running kernel.  A driver file/module
> > claims the cleancache_ops pointer (and should check to ensure
> > it is not already claimed).  And if nobody claims cleancache_ops,
> > the hooks should be as non-intrusive as possible.
> >
> > Also note that the operations occur on the order of the number
> > of I/O's, so definitely a lot, but "zillion" may be a bit high. :-)
> >
> > If you think this is a showstoppper, it could be changed
> > to be bound only at compile-time, but then (I think) the claimer
> > could never be a dynamically-loadable module.
> 
> Andrew is suggesting that rather than making cleancache_ops a pointer
> to
> a structure, just make it a structure, so that calling a function is a
> matter of cleancache_ops.func rather than cleancache_ops->func, thereby
> avoiding a pointer dereference.

OK, I see.  So the claimer of the cleancache_ops structure
just fills in all of the func fields individually?  That
would work too.  IIUC it wouldn't save any instructions
when cleancache_ops is unclaimed because it is still necessary
to check a func pointer against NULL, but would save an extra
pointer indirection and possible cache miss for every use
of any func when it is claimed.

I'll change that for next rev.

Thanks and sorry I misunderstood!
Dan
