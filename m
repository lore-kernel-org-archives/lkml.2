Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030489Ab2CFMQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:16:39 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48675 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab2CFMQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:16:37 -0500
Date: Tue, 6 Mar 2012 13:16:16 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5] EDAC core changes in order to properly report errors
 from all types of memory controllers
Message-ID: <20120306121616.GB11661@aftab>
References: <4F50DECB.8030200@redhat.com>
 <20120305110441.GC1070@aftab>
 <4F54A6FF.50502@redhat.com>
 <20120305124411.GD1070@aftab>
 <4F54C133.6040709@redhat.com>
 <20120305141349.GF1070@aftab>
 <4F54D4AF.9060802@redhat.com>
 <4F553764.5070305@redhat.com>
 <20120305232319.GA7175@aftab>
 <4F55F598.7050406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F55F598.7050406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 08:31:36AM -0300, Mauro Carvalho Chehab wrote:

[..]

> Breaking it into smaller patchsets is not trivial, as the analysis of the
> individual changesets only makes sense in the light of the big change on
> the edac core structures.

I don't believe that and LKML contains countless examples of how patches
can be split into simple hunks containing only one logical change.
Simply put yourself in the reviewer's place and try to imagine what kind
of patch format you'd like to see.

[..]

> On a csrow-based MC, dual-rank memories would be mapped as two separate 
> (csrow, channel) addresses. Each will have half of the DIMM size on each
> address. The above "emulation" creates two (csrow, channel) addreses for every
> FB-DIMM, filling just one, but only if the memory is dual-rank.
> 
> For a FB-DIMM controller, the number of ranks is just a detail associated with
> a given DIMM slot, as the memory is selected by slot, and not by rank.
> 
> So, the logic is completely broken for single-rank memories and half-broken for 
> double-rank ones.

I'm still wondering whether FBDIMM-based drivers should get their own
EDAC infrastructure and own nomenclature instead of fitting them in the
existing scheme...

> 
> This is an example of a patch that should not be fold.
> 
> After this patch, the memories on the i5000 machine I'm testing are properly
> reported, being single-rank or dual-rank.

How about instead of verbosely explaining in a mail why you're doing
what you're doing, you add that explanation to your patches so that even
the unlightened one can understand what you're doing? I think that will
benefit all.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
