Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1HDCxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 22:53:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:18006 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HDCxg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:6:1>);
	Wed, 3 Aug 2011 22:53:36 -0400
Message-Id: <4E3A17BD0200007800073FC5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Aug 2011 03:53:32 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <matt@console-pimps.org>, <linux-kernel@vger.kernel.org>
Cc: <fenghua.yu@intel.com>, <tony.luck@intel.com>, <hpa@linux.intel.com>,
        <matt.fleming@linux.intel.com>, <mjg@redhat.com>,
        <a.zummo@towertech.it>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Matt Fleming 08/03/11 11:04 PM >>> 
>From: Matt Fleming 
>
>A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86: 
>Serialize EFI time accesses on rtc_lock") because efi_get_time() and 
>friends can be called with rtc_lock already held by 
>read_persistent_time(), e.g. 
>
>timekeeping_init() 
>read_persistent_clock() <-- acquire rtc_lock 
>efi_get_time() 
>phys_efi_get_time() <-- acquire rtc_lock 
>
>Move the locking up into the caller of efi.get_time() and provide some 
>wrappers for use in other parts of the kernel instead of calling 
>efi.get_time(), etc directly. This way we can hide the rtc_lock dance 
>inside of arch/x86. 

Seems the wrong approach to me: The call happening with the lock held
is the wrong part imo, and hence the fix ought to be to drop the lock
there.

Jan
