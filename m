Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2CXSu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 14:50:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab2CXSu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 14:50:26 -0400
Message-ID: <4F6E1742.6060709@zytor.com>
Date: Sat, 24 Mar 2012 11:49:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Thomas Renninger <trenn@suse.de>,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com> <20120324092451.GA3352@liondog.tnic>
In-Reply-To: <20120324092451.GA3352@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Harald Hoyer, maintainer of dracut.  Harald, we're discussing
adding components to the initrd blob which is used during early boot.
We have at least two such users identified: microcode updates and ACPI
override.  The two proposals on the table is either to stick with cpio
format and using a special namespace (e.g. kernel/) or using a new
header for these early objects that would be skipped by the initramfs
decoder.]

On 03/24/2012 02:24 AM, Borislav Petkov wrote:
> On Fri, Mar 23, 2012 at 09:43:09PM -0700, H. Peter Anvin wrote:
>> By the way, if "relying on the bootloader" was an option in any way then
>> we would already have a solution in the form of the kernel data linked
>> list.  Unfortunately to the best of my knowledge not a single bootloader
>> provides support for it.
> 
> ... and that's unfortunate because if we had that support, we wouldn't
> need to redo the initrd each time microcode or BIOS tables change but
> simply point the boot loader to the updated images.
> 
> :-(
> 
> Btw, hpa, didn't you have someone working on early microcode loading,
> any results there?
> 

Yes... unfortunately between the kernel.org disaster and having a baby I
haven't had enough to time to get that work out of the freezer, which is
unfortunate in the extreme.

On the other hand, perhaps it is a good thing we didn't end up settling
on a protocol which was too narrow purpose for that one, too.

This is my current thinking, and please comment on this so we don't
spend a bunch of time bikeshedding this one... I'd like to come up with
something that we can implement and move on.

I have to say I'm personally leaning in the direction of just using a
special namespace and still encode things as cpio.  However, in order
for that to work we need to make sure that the invariant "early kernel
objects come before any compressed blob" is maintained at all times,
which might be sensitive.  However, it has serious advantages both from
a bootloader UI point of view (names are ASCII strings) and from a tools
point of view (it's just cpio, still.)

The main downside is that the cpio header is mostly in ASCII encoded
hexadecimal, which adds to the amount of code that needs to be ported
into "special" environments... not a problem for the ACPI converter but
for the early microcode it matters.

I might try to throw a minimal walker together and see how much code it
is, unless someone beats me to it ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

