Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab2B2Nh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:37:59 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38908 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab2B2Nh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:37:57 -0500
Date: Wed, 29 Feb 2012 14:37:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229133741.GF21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com>
 <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
 <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E22B1.6020505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 10:05:53AM -0300, Mauro Carvalho Chehab wrote:
> Em 29-02-2012 09:19, Borislav Petkov escreveu:
> > On Wed, Feb 29, 2012 at 09:04:46AM -0300, Mauro Carvalho Chehab wrote:
> >> Not all information is packed in the record. The record packs only what it
> >> is inside the MCE registers. However, for certain errors, it is needed to
> >> parse other hardware registers to decode the error (for example, on Sandy
> >> Bridge, the MCE registers don't contain the affected dimms).
> > 
> > If SB is not using MCA to report the error, it should use either a
> > generic TP like the trace_hw_error() example I gave last week, or rather
> > a TP which matches the hw registers of the reporting hardware scheme.
> 
> This is not what I said. On intel, both SB and Nehalem use MCA to report errors.
> Older chipsets don't use MCA.
> 
> However, there's a fundamental difference between SB and Nehalem:
> 
> - on Nehalem, the MCE status register encodes not only the error message; it
>   also encodes the DIMM that generated the  error. So, it is possible to 
>   completely decode the error on userspace, using only the MCE registers.

Well, depending on what Tony wants to do there, either decode the error
in the kernel and pass it on with the 'msg' arg or do the whole decoding
in userspace.

> - on SB, the MCE status register only has the error message. In order to get
>   the DIMM location, the driver needs to parse the registers that describe
>   how the DIMM's are organized (this is spread on dozens of PCI devices, and
>   200+ registers), and how they're interlaced, in order to convert the error 
>   address reported by the MCA into a DIMM location.

As I already said, amd64_edac does a similar thing does already so I
don't see any difference in the solutions there: decode to the DIMM and
pass the info through 'msg'.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
