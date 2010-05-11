Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0EKUvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:51:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab0EKUvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:51:51 -0400
Message-ID: <4BE9C342.1070104@zytor.com>
Date: Tue, 11 May 2010 13:51:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] x86/apic: allow use of lapic timer early calibration
 result
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain> <43F901BD926A4E43B106BF17856F0755A74B2827@orsmsx508.amr.corp.intel.com> <alpine.LFD.2.00.1005112146180.3401@localhost.localdomain> <43F901BD926A4E43B106BF17856F0755A74B28D6@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A74B28D6@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 01:46 PM, Pan, Jacob jun wrote:
> 
> The question I have is the reference clock used for calibrating those local timers,
> PIT, HPET, PM timer how should they be ranked. Can we make those known freq
> clocksource devices available at this point so that we can use the clocksource
> abstraction and its ranking automatically?
> 

Personally I'd rank the PMTMR first, then HPET, then PIT, just based on
the relative complexity and relative known bugginess of the various
implementations.

The PMTMRs main defect is that it can't generate an interrupt; it's just
a dumb counter.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

