Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1HDLhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:37:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51662 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HDLh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:37:29 -0400
Date: Thu, 4 Aug 2011 12:36:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Message-ID: <20110804113655.GA30077@srcf.ucam.org>
References: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
 <CANcMJZDqYJHTTPifrxr7cDVA_S+PRwy6AzjO-54ucvpnyoRADA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZDqYJHTTPifrxr7cDVA_S+PRwy6AzjO-54ucvpnyoRADA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:22:24AM -0700, john stultz wrote:

> Sorry if this should be obvious, but is there a reason your not using
> your own internal lock for serializing the efi bits rather then using
> the rtc_lock?

On x86 systems the EFI clock is almost certainly the AT RTC, so it's 
necessary to serialise accesses between EFI and the traditional clock 
interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
