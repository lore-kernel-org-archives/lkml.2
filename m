Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1HERE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:04:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:21177 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1HERE5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:6:1>);
	Fri, 5 Aug 2011 13:04:57 -0400
Message-Id: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 05 Aug 2011 18:04:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <matt@console-pimps.org>
Cc: <fenghua.yu@intel.com>, <tony.luck@intel.com>, <hpa@linux.intel.com>,
        <mjg@redhat.com>, <a.zummo@towertech.it>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Matt Fleming  08/04/11 11:33 AM >>>
>On Thu, 2011-08-04 at 03:53 +0100, Jan Beulich wrote:
>> 
>> Seems the wrong approach to me: The call happening with the lock held
>> is the wrong part imo, and hence the fix ought to be to drop the lock
>> there.
>
>But what about other platforms that provide a get_wallclock()
>implementation such as the kvm or xen code? If we called get_wallclock()

Virtual platforms will have to take care of the serialization in the
host anyway, so the guest side implementation of getwallclock et al
is entirely unaffected.

>without rtc_lock held we'd be requiring everyone to lock it in their
>clock code, which is unnecessary work and increases the amount of code
>that touches rtc_lock (not to mention spreading it across several
>files).
>
>I think it's much better to do the locking as high up the callstack as
>possible and preferably in as few places as possible.

I agree to the "as few places as possible" part.

Jan

