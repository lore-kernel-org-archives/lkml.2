Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2CYIya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 04:54:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42858 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab2CYIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 04:54:26 -0400
Date: Sun, 25 Mar 2012 10:54:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
Message-ID: <20120325085420.GA12565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>,
	eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
	robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
 <201203240242.07724.trenn@suse.de>
 <4F6D2AF8.3070707@zytor.com>
 <201203240402.38749.trenn@suse.de>
 <4F6D50DD.4050306@zytor.com>
 <20120324092451.GA3352@liondog.tnic>
 <4F6E1742.6060709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6E1742.6060709@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 11:49:38AM -0700, H. Peter Anvin wrote:
> Yes... unfortunately between the kernel.org disaster and having a baby I

Congrats on the second one!

> haven't had enough to time to get that work out of the freezer, which is
> unfortunate in the extreme.
> 
> On the other hand, perhaps it is a good thing we didn't end up settling
> on a protocol which was too narrow purpose for that one, too.
> 
> This is my current thinking, and please comment on this so we don't
> spend a bunch of time bikeshedding this one... I'd like to come up with
> something that we can implement and move on.
> 
> I have to say I'm personally leaning in the direction of just using a
> special namespace and still encode things as cpio.  However, in order
> for that to work we need to make sure that the invariant "early kernel
> objects come before any compressed blob" is maintained at all times,

That actually makes sense for ucode because we want it as early as
possible.

> which might be sensitive.  However, it has serious advantages both from
> a bootloader UI point of view (names are ASCII strings) and from a tools
> point of view (it's just cpio, still.)
> 
> The main downside is that the cpio header is mostly in ASCII encoded
> hexadecimal, which adds to the amount of code that needs to be ported
> into "special" environments... not a problem for the ACPI converter but
> for the early microcode it matters.

One other downside for this approach would be the need to have
initrd/initramfs support always compiled into the kernel in order to do
all those things but, hey, distro kernels already have that so we're
probably stuck with it anyway.

And, if someone wants to add the support to the bootloader later, he
can still do that by handing in cpio archives to the kernel for further
processing...

-- 
Regards/Gruss,
    Boris.
