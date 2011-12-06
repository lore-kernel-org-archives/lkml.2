Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1LFSpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:45:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1LFSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:45:20 -0500
MIME-Version: 1.0
In-Reply-To: <4EDDD0B5.3010702@linux.intel.com>
References: <4ed5352d208477d14@agluck-desktop.sc.intel.com>
	<4EDDD0B5.3010702@linux.intel.com>
Date: Tue, 6 Dec 2011 10:45:19 -0800
X-Google-Sender-Auth: zpzrz6pURyXy9BmUK75yjL7K8Ks
Message-ID: <CA+8MBbKtJTunqid6fbv5pPX9BqCa0F-QGrqtTQqdz45yY39hGg@mail.gmail.com>
Subject: Re: [PATCH] acpi-apei-einj: add extensions to EINJ from rev 5.0 of
 acpi spec
From: Tony Luck <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 12:22 AM, Chen Gong <gong.chen@linux.intel.com> wrote:
> I don't think one knows how to set *vendor_flags* correctly if no any
> instructions.

Agreed - more documentation would help here - but I suspect that it
needs to come
from a vendor implementing an extension for specifics ... but for general
how to use this - see more comments below.

> need explanation in the document how to set error type in ACPI 5.0.
>
> In the spec it doesn't say this bit field is filled by the user, from
> the codes I have following conclusion: one can set error type as 0x2,
> 0x4, 0x8 etc. or 0x80000002, 0x80000004, 0x80000008 etc, right?

The spec is pretty vague here - I'm assuming that as soon as the 0x80000000
bit is seen, the rest of the bits are fair game for the vendor to do
anything they
like.  So I provided a way to set the error_type because I don't think there is
any association between bits and error type.  E.g. one vendor could use
0x80000001 for some special memory operation - so expect a memory address
and mask, while another vendor could use the same 0x80000001 for a PCIe
operation, so want to see a segment/bus/device/function.  So I tried to be
flexible.  I'd expect that an application trying to use this would look at the
contents of the /sys/kernel/debug/apei/einj/vendor to know that they were
on the right platform, with the device/rev_id to use whatever vendor extension
they want.  But this needs more (some :-) ) Documentation

Of course there is still some vendor defined memory at the very end of the
structure that I have absolutely no idea what to do with.  I've
ignored it for now,
but if some vendor does do something with it, we will need another vendor_blob
interface to allow arbitrary bytes to be written to (and read from?)
that area (just
checking the size).

The whole vendor extension part is very speculative on my part as I don't have
any solid examples to test.  I do have a platform that provides the
structure. But
I don't know whether it actually implements any extended operations.

-Tony
