Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032371Ab2COVjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:39:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:46276 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032311Ab2COVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:39:12 -0400
Date: Thu, 15 Mar 2012 22:38:44 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120315213844.GA3781@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
 <20120315113115.GA32149@aftab>
 <4F61E35B.9000906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61E35B.9000906@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:40:59AM -0300, Mauro Carvalho Chehab wrote:
> > What are you talking about? Those per-rank counters should be the same
> > as the per-csrow ch0 and ch1 counters...
> 
> Yes, but with your proposal, the per-csrow counters will not be added
> (the equivalent of):
> 	/sys/devices/system/edac/mc/mc0/csrow0/ue_count
> 	/sys/devices/system/edac/mc/mc0/csrow0/ce_count

What the hell? Those are already there:

/sys/devices/system/edac/mc/mc0/csrow0/
|-- ce_count
|-- ch0_ce_count
|-- ch0_dimm_label
|-- ch1_ce_count
|-- ch1_dimm_label
|-- dev_type
|-- edac_mode
|-- mem_type
|-- size_mb
`-- ue_count

and since userspace uses them, they cannot be removed.

> > It depends - if the 128 bit word comes from a single DIMM (unganged
> > mode) then you have a per-rank UE.
> 
> True, and there are other types of ECC logic that would allow to identify
> what DIMM/rank produced the error.
> 
> Yet, the typical case is to use two DIMMs for a 128-bits cacheline
> on separate channels, due to performance improvements, and ECC chipkill
> using the 128+16 bits, as it improves the probability of error correction.

... and in this typical case, on smart hardware you can get the rank
too. If one cannot discern between the two DIMMs, then there should be
one counter and the other one should be a symlink to that counter, or
something to that effect.

> >> Of course, the EDAC logic could increment multiple UE error counters
> >> in such case, (meaning that an error happened on either one of the
> >> affected DIMMs/Ranks) but this is a different behavior than the
> >> current API.
> > 
> > Well, the API should be changed to accomodate such configurations.
> 
> True, but changing the propagation logic to propagate the error down
> to the several DIMMs from where the error might have occurred is:
> 
> 	- the opposite of the current propagation logic;
> 
> 	- the opposite on how ITU-T TMN architecture and all EMS/NMS
> 	  implementations I'm aware with work.
> 
> So, using such propagation logic doesn't sound right to me. What I'm
> saying is that, if all the driver can be sure is that the error happened
> at the csrow level, it should not propagate the errors to the channel
> level. 
> 
> So, I think that csrow-level counter is needed (and the equivalent
> "group" counters for non-rank-based memory controllers).

See above, we already have 'ce_count' and 'ue_count' and those are
csrow-level counters.

> 
> Regards,
> Mauro.
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
