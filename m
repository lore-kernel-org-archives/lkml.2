Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479Ab2DLT0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:26:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:37639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2DLT0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131769960"
Message-ID: <4F872C7B.6000106@linux.intel.com>
Date: Thu, 12 Apr 2012 12:26:51 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com> <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos> <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com> <alpine.LFD.2.02.1204121055200.2542@ionos> <20120412142904.GA4130@srcf.ucam.org> <alpine.LFD.2.02.1204121903250.2542@ionos> <alpine.LFD.2.02.1204121907330.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204121907330.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I feared that. So now is the question whether there is a way to mask
>> the interrupt at the "device" level.

Probably not. Len?

> If not, I could be persuaded to provide a mechanism to force thread
> all interrupts which are on that line, if there's a good argument to
> do so.

Hmm, we could probably just use a work queue for this instead. I guess i 
drank the threaded
interrupt kool aid too much when I did the patch :-)

I'll switch over to a workqueue.

Meanwhile the patch can be just reverted. The patch that needed it 
(delays in EC access to
work around buggy Acer EC) was not merged by  Len so far, so there's 
nothing in tree right
now that relies on the thread.

For 3.4 I think reverting is the right approach.

-Andi

