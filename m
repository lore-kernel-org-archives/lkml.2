Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247Ab2B2RQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:16:48 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39991 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031234Ab2B2RQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:16:44 -0500
Date: Wed, 29 Feb 2012 18:16:26 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229171626.GJ21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com>
 <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com>
 <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 04:58:09PM +0000, Luck, Tony wrote:
> > - severity: No real need for it. If the error is severe enough, the
> > kernel handles automatically, i.e. memory poisoning and recovery. In all
> > the other cases it is not severe enough.
> 
> We'll never see fatal errors via the perf/tracepoint (no way the RAS daemon
> will run to pull them). But we will see both corrected error chatter and
> recovered uncorrectable errors. I would be able to tell these apart.
> Corrected errors in small doses are normal and don't require any
> action beyond logging so you can see whether there are enough to cross
> a threshold and cause alarm. Recovered uncorrectable errors are going
> to be much rarer, and I think deserve closer scrutiny - even when there
> is just one of them.
> If you drop the severity field, is there some other way to make this
> distinction?

Err, MCi_STATUS bits like bit 55 (Action Required) and 56 (Signaled #MC)
in your case...?

> > - silkscreen_label: <sarcasm> yeah, I'm getting a, say, a Data
> > Cache error during an L1 linefill from L2, what the f*ck does the
> > silkscreen label mean for such an error?! Well, nobody knows wtf it
> > means!</sarcasm>
> 
> Cache error should point to a cpu socket - I'd like to have a silk
> screen label for that (are they numbered "0, 1, 2 ..." on the motherboard
> or "1, 2, 3 ..."?)  No idea where we'd get that information from. dmidecode
> shows "Socket Designation: CPU 1" (and "2") for my current Sandy Bridge
> system. I'd have to pull the system apart to see if those are helpful
> in identifying which physical cpu is which.

First of all, silkscreen label denotes DIMM slots in this context
AFAICT. Concerning CPU sockets, I'm not aware of a method to read out
the silkscreen labels at the CPU sockets, are you? Or am I missing
something?

IOW, we want to assume that cores 0, 1, 2 ... k-1 are on node 0; k, k+1
... 2k-1 belong to node 1, etc., where k is the number of cores on a
socket and thus we have a regular core enumeration on the box.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
