Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0EGW2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:28:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34559 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0EGW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:28:34 -0400
Message-ID: <4BE493D6.6000105@zytor.com>
Date: Fri, 07 May 2010 15:27:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>	<1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>	<4BE478C1.2060602@zytor.com>	<4BE4791B.1060304@linux.intel.com>	<4BE479EA.3080005@zytor.com> <20100507232448.343b5ebc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100507232448.343b5ebc@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 03:24 PM, Alan Cox wrote:
>> I'd be cool skipping it for family 5 or newer.  I'm just wondering if we
>> should kill it completely -- IIRC it was only a handful of 386/486
>> systems which had problems, usually due to marginal power supplies which
>> couldn't handle the noise of a variable load (DOS not having any power
>> management would run at a reliable 100% load) -- that's not exactly the
>> type of systems which would have survived to modern day.
> 
> Also SMM and hardware bugs on some platforms - Cyrix MediaGX 5510 for
> example where a hlt at the wrong moment during ATA transfers hung the box
> until power cycle. But all old old stuff.

I think family < 5 seems a reasonable cutoff.

Note that the ATA transfer bug you describe above would not be caught by
the existing check.

	-hpa

