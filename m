Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2CYJHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 05:07:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab2CYJHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 05:07:09 -0400
Date: Sun, 25 Mar 2012 11:07:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
Message-ID: <20120325090705.GB12565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
	vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
	robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
	Harald Hoyer <harald@redhat.com>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
 <4F6CD79A.8020805@zytor.com>
 <201203240242.07724.trenn@suse.de>
 <4F6D2AF8.3070707@zytor.com>
 <20120324184238.GB13978@phenom.dumpdata.com>
 <4F6E1D6F.4000308@zytor.com>
 <20120324191718.GA3927@phenom.dumpdata.com>
 <4F6E48CD.9050002@zytor.com>
 <4F6E9C51.9000406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6E9C51.9000406@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 09:17:21PM -0700, H. Peter Anvin wrote:
> The more I think about it the more I really think this is the right
> approach.  For microcode, this means we don't have to worry about
> creating a super-container for the various microcode formats; we can
> simply have:
> 
> 	kernel/x86/microcode/GenuineIntel
> 	kernel/x86/microcode/AuthenticAMD
> 
> ... which solves the problem neatly.

Yes, this is actually pretty neat. Basically, distro vendors will get
ucode images from the resp. hw vendors, put them in the proper hierarchy
as above and generate the cpio archive, easy.

> It does beg the question if you want to be able to have multiple:
> 
> 	kernel/acpi/...
> 
> ... files, to make managing different tables easier, or is that overkill?

Well, like the above, different sub-namespaces...

-- 
Regards/Gruss,
    Boris.
