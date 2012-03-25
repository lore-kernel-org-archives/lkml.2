Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab2CYESN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 00:18:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab2CYESL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 00:18:11 -0400
Message-ID: <4F6E9C51.9000406@zytor.com>
Date: Sat, 24 Mar 2012 21:17:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <20120324184238.GB13978@phenom.dumpdata.com> <4F6E1D6F.4000308@zytor.com> <20120324191718.GA3927@phenom.dumpdata.com> <4F6E48CD.9050002@zytor.com>
In-Reply-To: <4F6E48CD.9050002@zytor.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2012 03:21 PM, H. Peter Anvin wrote:
> The attached cpio-parsing code compiles to 458 bytes on x86-64 and 476
> bytes on i386, and that is without any library dependencies at all.
> Again, it will completely stop at the first compressed data item, so any
> such kernel objects absolutely will have to be first.  In good Linux
> tradition, it is also completely untested.
> 
> However, given that very reasonable size I would think that this is a
> reasonable approach.  Anyone who has a better suggestion for the
> namespace than "kernel/"?
> 

The more I think about it the more I really think this is the right
approach.  For microcode, this means we don't have to worry about
creating a super-container for the various microcode formats; we can
simply have:

	kernel/x86/microcode/GenuineIntel
	kernel/x86/microcode/AuthenticAMD

... which solves the problem neatly.

It does beg the question if you want to be able to have multiple:

	kernel/acpi/...

... files, to make managing different tables easier, or is that overkill?

	-hpa

