Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2C0M0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:26:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59873 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2C0M0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <4F69DA92.6030107@redhat.com>
References: <20120321063350.GA3468@leaf> <4F69DA92.6030107@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 27 Mar 2012 14:25:41 +0200
Message-ID: <CAPXgP11tYWKtbJmu98unVfr++XS_PkJwyjdMy-PgOrU-xofT7Q@mail.gmail.com>
Subject: Re: [PATCH] kvm-intel: Auto-load on CPUs with VMX.
To: Avi Kivity <avi@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 14:41, Avi Kivity <avi@redhat.com> wrote:
> On 03/21/2012 08:33 AM, Josh Triplett wrote:
>> Enable x86 feature-based autoloading for the kvm-intel module on CPUs
>> with X86_FEATURE_VMX.
>>
>> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
>> ---
>>
>> I've tested this and it works correctly.  I can also supply the obvious
>> equivalent patch for kvm-amd on AMD CPUs with SVM, but I don't have any
>> such CPUs to test that on.
>>
>
> On the one hand this makes sense and is consistent with how other
> modules are loaded.  On the other hand this will waste memory for
> non-virt users running on distro kernels (but distro kernels can
> override this new behaviour anyway).
>
> I'm inclined to apply, but will wait for more comments.

Today, we auto-load matching modules for everything we find. It seems
still the best compromise for the default behaviour to make things
work without special care or knowledge, especially for distribution
users.

People who care, can simply 'optimize' that with blacklisting the
aliases in the modprobe config. That way stuff does not get
auto-loaded, but can still be modprobed manually by the module name.

We used to load these modules with rather broken shell scripts, poking
around in /proc/cpuinfo during bootup, anyway. So this standard way of
using an alias is by far the better alternative to it, and I'm all for
doing that.

For what it's worth:
  Acked-By: Kay Sievers <kay@vrfy.org>

Thanks,
Kay
