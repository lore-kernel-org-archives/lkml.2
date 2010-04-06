Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0DFR2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:28:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:48972 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab0DFR2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:28:35 -0400
MIME-Version: 1.0
Message-ID: <0866dc77-b531-4128-bb63-0d4859099bc8@default>
Date: Tue, 6 Apr 2010 10:27:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: RE: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
	<20100405142419.2c9bea3d.akpm@linux-foundation.org>	<4BBA5E1C.10706@goop.org>
	<20100405151720.8a6ac5e3.akpm@linux-foundation.org>
	<4BBA7226.9080508@goop.org>
 <20100405163458.135fa319.akpm@linux-foundation.org
 4BBB61AF.6000608@redhat.com>
In-Reply-To: <4BBB61AF.6000608@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBB6F27.0163:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Tuesday, April 06, 2010 10:31 AM
> >
> >> And is there some way to get the vm subsystem to provide
> backpressure:
> >> "I'm getting desperately short of memory!"?
> >>
> > Not really.  One could presumably pull dopey tricks by hooking into
> > slab shrinker registration or even ->writepage().  But cooking up
> > something explicit doesn't sound too hard - the trickiest bit would
> be
> > actually defining what it should do.
> 
> The oft-suggested approach is to look at the I/O load from guests and
> give more memory to those that are thrashing.  Of course not all I/O is
> directly due to memory pressure.

Which is why it is very useful to be able to differentiate between:
1) refault I/O (due to pagecache too small, and PFRA choices)
2) swap I/O (due to memory pressure)
3) normal file dirty writes (due to an app's need for persistence)

Again, the cleancache and frontswap hooks and APIs separate these
out nicely.

Dan "who worries he is sounding like a broken record"
