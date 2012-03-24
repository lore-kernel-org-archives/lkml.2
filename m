Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2CXTQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 15:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36260 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab2CXTQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 15:16:17 -0400
Message-ID: <4F6E1D6F.4000308@zytor.com>
Date: Sat, 24 Mar 2012 12:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <20120324184238.GB13978@phenom.dumpdata.com>
In-Reply-To: <20120324184238.GB13978@phenom.dumpdata.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2012 11:42 AM, Konrad Rzeszutek Wilk wrote:
> 
> Probably should also have:
> 		u32 version;
> 
> in case we decide to expand this structure in the future, and:
>> 		u32 type;	/* 1 = file data, 2 = ACPI, 3 = microcode... */
>> 		u32 length;	/* Length of data object */
>> 	};
> 
> and encapsulate the whole thing in a 4K union?
> 

For "version" you'd have to define what happens if you see a version
number you don't recognize, and why that is in any way better than
changing the magic number or the type.  It is something that people like
to throw in without thinking about it, and that is a mistake.

Forcing everything to be page-aligned may be a good idea, although that
assumes all bootloaders actually align them that way...

> 
> Perhaps the header should be in big-endian (that is the same as the network
> byte order, right?) and each sub-type can define its own endian?
> 

The content of the encapsulation is its own thing; it will be different
for different types as most of them already

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

