Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2CEJRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:17:23 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab2CEJRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:17:22 -0500
Date: Mon, 5 Mar 2012 10:17:01 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mce: Slim up struct mce
Message-ID: <20120305091701.GB1070@aftab>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-2-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F0410BD@ORSMSX104.amr.corp.intel.com>
 <20120303073726.GA16816@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303073726.GA16816@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 08:37:26AM +0100, Ingo Molnar wrote:
> 
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> > > Drop unused ->apicid, make ->socketid __u16 since it is 
> > > copied from struct cpuinfo_86.phys_proc_id, reorder members 
> > > and adjust padding so that it remains packed and on a 
> > > 64-byte boundary.
> > 
> > This structure is user visible via /dev/mcelog.  The mcelog(8) 
> > daemon has been coded to cope with extra fields being added to 
> > the end of the structure (an old daemon that doesn't know what 
> > they are will just skip over them). But things will break if 
> > you change the offsets of any fields that it does know about.
> 
> Please separate out a 'struct mce_legacy' data type that 
> contains the /dev/mcelog format, and use it in the place that 
> outputs to /dev/mcelog (and convert from 'struct mce' to 'struct 
> mce_legacy' and back when interacting with /dev/mcelog).

Either that or I'll save my patch for when we remove /dev/mcelog
altogether.

> This keeps 'struct mce' kernel internal and flexible. A pure 
> kernel internal structure should never have been exported like 
> this to begin with, doing that results in problems like this.

Ho-hum.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
