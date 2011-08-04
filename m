Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1HDKWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:22:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42747 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1HDKWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
References: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
Date: Thu, 4 Aug 2011 03:22:24 -0700
X-Google-Sender-Auth: UDbWlSh95BE8cCy067XvoGx2UmQ
Message-ID: <CANcMJZDqYJHTTPifrxr7cDVA_S+PRwy6AzjO-54ucvpnyoRADA@mail.gmail.com>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: john stultz <johnstul@us.ibm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 2:04 PM, Matt Fleming <matt@console-pimps.org> wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
>
> A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> friends can be called with rtc_lock already held by
> read_persistent_time(), e.g.
>
> timekeeping_init()
>    read_persistent_clock()     <-- acquire rtc_lock
>        efi_get_time()
>            phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
>
> Move the locking up into the caller of efi.get_time() and provide some
> wrappers for use in other parts of the kernel instead of calling
> efi.get_time(), etc directly. This way we can hide the rtc_lock dance
> inside of arch/x86.

Sorry if this should be obvious, but is there a reason your not using
your own internal lock for serializing the efi bits rather then using
the rtc_lock?

thanks
-john
