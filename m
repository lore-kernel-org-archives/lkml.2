Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0DYPa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:30:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16473 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0DYPaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:30:55 -0400
MIME-Version: 1.0
Message-ID: <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default>
Date: Sun, 25 Apr 2010 08:29:24 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
 <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default>
 <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default>
 <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default>
 <4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
 <4BD43182.1040508@redhat.com> <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default
 4BD44E74.2020506@redhat.com>
In-Reply-To: <4BD44E74.2020506@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BD46013.0133:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > While I admit that I started this whole discussion by implying
> > that frontswap (and cleancache) might be useful for SSDs, I think
> > we are going far astray here.  Frontswap is synchronous for a
> > reason: It uses real RAM, but RAM that is not directly addressable
> > by a (guest) kernel.  SSD's (at least today) are still I/O devices;
> > even though they may be very fast, they still live on a PCI (or
> > slower) bus and use DMA.  Frontswap is not intended for use with
> > I/O devices.
> >
> > Today's memory technologies are either RAM that can be addressed
> > by the kernel, or I/O devices that sit on an I/O bus.  The
> > exotic memories that I am referring to may be a hybrid:
> > memory that is fast enough to live on a QPI/hypertransport,
> > but slow enough that you wouldn't want to randomly mix and
> > hand out to userland apps some pages from "exotic RAM" and some
> > pages from "normal RAM".  Such memory makes no sense today
> > because OS's wouldn't know what to do with it.  But it MAY
> > make sense with frontswap (and cleancache).
> >
> > Nevertheless, frontswap works great today with a bare-metal
> > hypervisor.  I think it stands on its own merits, regardless
> > of one's vision of future SSD/memory technologies.
> 
> Even when frontswapping to RAM on a bare metal hypervisor it makes
> sense
> to use an async API, in case you have a DMA engine on board.

When pages are 2MB, this may be true.  When pages are 4KB and 
copied individually, it may take longer to program a DMA engine 
than to just copy 4KB.

But in any case, frontswap works fine on all existing machines
today.  If/when most commodity CPUs have an asynchronous RAM DMA
engine, an asynchronous API may be appropriate.  Or the existing
swap API might be appropriate. Or the synchronous frontswap API
may work fine too.  Speculating further about non-existent
hardware that might exist in the (possibly far) future is irrelevant
to the proposed patch, which works today on all existing x86 hardware
and on shipping software.

