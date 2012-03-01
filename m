Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab2CALaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:30:10 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43743 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2CALaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:30:07 -0500
Date: Thu, 1 Mar 2012 12:29:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120301112949.GA32410@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com>
 <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com>
 <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
 <20120229171626.GJ21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:33:51PM +0000, Luck, Tony wrote:
> > IOW, we want to assume that cores 0, 1, 2 ... k-1 are on node 0; k, k+1
> > ... 2k-1 belong to node 1, etc., where k is the number of cores on a
> > socket and thus we have a regular core enumeration on the box.
> 
> Sounds dubious:
> 
> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
> Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
> Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31
> Brought up 32 CPUs
> 
> Now those are logical cpu numbers, and we brought up the first HT
> thread on each core first, and then came around for a 2nd pass
> bringing up the other HT thread.  This order is determined by
> how the BIOS lists the cpus (and in this case it seems to be
> doing so according to recommendations) - so here our core numbers
> will match what you said. But the BIOS could do something
> strange and list logical cpus alternating between sockets. In
> which case cores 0, 2, 4, 6 ... would be on node 0, and cores
> 1, 3, 5, 7, ... on node 1.

Ok, the example above actually confirms my fear that you won't be always
able to map back to a physical socket from the CPU number. So, we'll
need the ->socketid field which is the physical processor ID we get from
CPUID leafs.

Then, mapping back the socketid to the silkscreen labels on the boards
should be easy because on the boxes I have here, they go like this: P0,
P1, ..., where P0 is the socket containing the BSP, P1 is the second
socket etc. I'm guessing this is similar on Intel boards...?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
