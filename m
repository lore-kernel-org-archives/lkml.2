Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2CCHhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 02:37:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2CCHhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 02:37:37 -0500
Date: Sat, 3 Mar 2012 08:37:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/4] mce: Slim up struct mce
Message-ID: <20120303073726.GA16816@elte.hu>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-2-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F0410BD@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F0410BD@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > Drop unused ->apicid, make ->socketid __u16 since it is 
> > copied from struct cpuinfo_86.phys_proc_id, reorder members 
> > and adjust padding so that it remains packed and on a 
> > 64-byte boundary.
> 
> This structure is user visible via /dev/mcelog.  The mcelog(8) 
> daemon has been coded to cope with extra fields being added to 
> the end of the structure (an old daemon that doesn't know what 
> they are will just skip over them). But things will break if 
> you change the offsets of any fields that it does know about.

Please separate out a 'struct mce_legacy' data type that 
contains the /dev/mcelog format, and use it in the place that 
outputs to /dev/mcelog (and convert from 'struct mce' to 'struct 
mce_legacy' and back when interacting with /dev/mcelog).

This keeps 'struct mce' kernel internal and flexible. A pure 
kernel internal structure should never have been exported like 
this to begin with, doing that results in problems like this.

Thanks,

	Ingo
