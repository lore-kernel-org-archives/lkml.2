Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1HDJdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:33:45 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50215 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab1HDJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:33:39 -0400
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
        hpa@linux.intel.com, mjg@redhat.com, a.zummo@towertech.it
In-Reply-To: <4E3A17BD0200007800073FC5@nat28.tlf.novell.com>
References: <4E3A17BD0200007800073FC5@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 10:33:36 +0100
Message-ID: <1312450416.10579.70.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 03:53 +0100, Jan Beulich wrote:
> 
> Seems the wrong approach to me: The call happening with the lock held
> is the wrong part imo, and hence the fix ought to be to drop the lock
> there.

But what about other platforms that provide a get_wallclock()
implementation such as the kvm or xen code? If we called get_wallclock()
without rtc_lock held we'd be requiring everyone to lock it in their
clock code, which is unnecessary work and increases the amount of code
that touches rtc_lock (not to mention spreading it across several
files).

I think it's much better to do the locking as high up the callstack as
possible and preferably in as few places as possible.

-- 
Matt Fleming, Intel Open Source Technology Center

