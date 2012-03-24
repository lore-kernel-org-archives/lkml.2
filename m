Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2CXTWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 15:22:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51810 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2CXTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 15:22:04 -0400
Date: Sat, 24 Mar 2012 15:17:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
Message-ID: <20120324191718.GA3927@phenom.dumpdata.com>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
 <4F6CD79A.8020805@zytor.com>
 <201203240242.07724.trenn@suse.de>
 <4F6D2AF8.3070707@zytor.com>
 <20120324184238.GB13978@phenom.dumpdata.com>
 <4F6E1D6F.4000308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6E1D6F.4000308@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F6E1ECC.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 12:15:59PM -0700, H. Peter Anvin wrote:
> On 03/24/2012 11:42 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > Probably should also have:
> > 		u32 version;
> > 
> > in case we decide to expand this structure in the future, and:
> >> 		u32 type;	/* 1 = file data, 2 = ACPI, 3 = microcode... */
> >> 		u32 length;	/* Length of data object */
> >> 	};
> > 
> > and encapsulate the whole thing in a 4K union?
> > 
> 
> For "version" you'd have to define what happens if you see a version
> number you don't recognize, and why that is in any way better than
> changing the magic number or the type.  It is something that people like
> to throw in without thinking about it, and that is a mistake.

I was thinking of interface version. So the first would be 1, and if
there are extensions (so version 2 for example), it should support 1 and 2.
The idea is to expand past the structure with newer additions without
breaking the binary interface.

> 
> Forcing everything to be page-aligned may be a good idea, although that
> assumes all bootloaders actually align them that way...

Oh, and be 4K.
> 
> > 
> > Perhaps the header should be in big-endian (that is the same as the network
> > byte order, right?) and each sub-type can define its own endian?
> > 
> 
> The content of the encapsulation is its own thing; it will be different
> for different types as most of them already
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
