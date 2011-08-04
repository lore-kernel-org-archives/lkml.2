Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1HDKha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:37:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42271 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640Ab1HDKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:37:23 -0400
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <CANcMJZDqYJHTTPifrxr7cDVA_S+PRwy6AzjO-54ucvpnyoRADA@mail.gmail.com>
References: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
	 <CANcMJZDqYJHTTPifrxr7cDVA_S+PRwy6AzjO-54ucvpnyoRADA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 11:36:59 +0100
Message-ID: <1312454219.10579.80.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 03:22 -0700, john stultz wrote:
> On Wed, Aug 3, 2011 at 2:04 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > From: Matt Fleming <matt.fleming@linux.intel.com>
> >
> > A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> > Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> > friends can be called with rtc_lock already held by
> > read_persistent_time(), e.g.
> >
> > timekeeping_init()
> >    read_persistent_clock()     <-- acquire rtc_lock
> >        efi_get_time()
> >            phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
> >
> > Move the locking up into the caller of efi.get_time() and provide some
> > wrappers for use in other parts of the kernel instead of calling
> > efi.get_time(), etc directly. This way we can hide the rtc_lock dance
> > inside of arch/x86.
> 
> Sorry if this should be obvious, but is there a reason your not using
> your own internal lock for serializing the efi bits rather then using
> the rtc_lock?

Jan wrote the original code that started using the rtc_lock inside the
EFI bits here, ef68c8f87ed1 ("x86: Serialize EFI time accesses on
rtc_lock").

Jan?
 
-- 
Matt Fleming, Intel Open Source Technology Center

