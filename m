Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0D0Ocq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:32:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab0D0Oco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:32:44 -0400
MIME-Version: 1.0
Message-ID: <36b23d5c-ca25-44b5-be9f-b7ceaab0dd2e@default>
Date: Tue, 27 Apr 2010 07:32:00 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default>
 <4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
 <4BD43182.1040508@redhat.com>
 <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default4BD44E74.2020506@redhat.com>
 <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default 20100427125624.GB3681@ucw.cz>
In-Reply-To: <20100427125624.GB3681@ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BD6F56D.0130:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stop right here. Instead of improving existing swap api, you just
> create one because it is less work.
> 
> We do not want apis to cummulate; please just fix the existing one.

> If we added all the apis that worked when proposed, we'd have
> unmaintanable mess by about 1996.
> 
> Why can't frontswap just use existing swap api?

Hi Pavel!

The existing swap API as it stands is inadequate for an efficient
synchronous interface (e.g. for swapping to RAM).  Both Nitin
and I independently have found this to be true.  But swap-to-RAM
is very useful in some cases (swap-to-kernel-compressed-RAM
and swap-to-hypervisor-RAM and maybe others) that were not even
conceived many years ago at the time the existing swap API was
designed for swap-to-disk.  Swap-to-RAM can relieve memory
pressure faster and more resource-efficient than swap-to-device
but must assume that RAM available for swap-to-RAM is dynamic
(not fixed in size).  (And swap-to-SSD, when the SSD is an
I/O device on an I/O bus is NOT the same as swap-to-RAM.)

In my opinion, frontswap is NOT a new API, but the simplest
possible extension of the existing swap API to allow for
efficient swap-to-RAM.  Avi's comments about a new API
(as he explained later in the thread) refer to a new API
between kernel and hypervisor, what is essentially the
Transcendent Memory interface.  Frontswap was separated from
the tmem dependency to enable Nitin's swap-to-kernel-compressed-RAM
and the possibility that there may be other interesting
swap-to-RAM uses.

Does this help?

Dan
