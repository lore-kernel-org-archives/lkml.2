Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2B2RTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:19:24 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40035 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2B2RTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:23 -0500
Date: Wed, 29 Feb 2012 18:19:05 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229171905.GK21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com>
 <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
 <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com>
 <20120229133741.GF21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F04012A@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F04012A@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:11:08PM +0000, Luck, Tony wrote:
> >> - on Nehalem, the MCE status register encodes not only the error message; it
> >>   also encodes the DIMM that generated the  error. So, it is possible to 
> >>   completely decode the error on userspace, using only the MCE registers.
> >
> > Well, depending on what Tony wants to do there, either decode the error
> > in the kernel and pass it on with the 'msg' arg or do the whole decoding
> > in userspace.
> 
> For best results - we should decode right away in the kernel. Decoding later
> requires that we carry a lot of additional information about the system
> configuration at the time of the error.  Consider the case of a hard error
> (either fatal or recoverable). If the system reboots, then the DIMM
> with the error should fail self test - and thus be mapped out of the system.
> If the error analyzer doesn't realize that this has happened, it will be
> very confused. Even if it does notice - the Sandy bridge decoder won't be
> able to check that the right DIMM was mapped out (since the configuration
> registers it reads to map addresses to DIMMS will now be set for the new
> configuration, with different mappings).

Absolutely!

And also, you've lost the moment the system reboots and you haven't
gotten all the info needed for decoding the error.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
