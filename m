Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2CYXa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:30:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45453 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab2CYXaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:30:55 -0400
Message-ID: <4F6FAA63.2020107@zytor.com>
Date: Sun, 25 Mar 2012 16:29:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <20120324184238.GB13978@phenom.dumpdata.com> <4F6E1D6F.4000308@zytor.com> <20120324191718.GA3927@phenom.dumpdata.com> <4F6E48CD.9050002@zytor.com> <4F6E4E3A.7060307@kernel.org> <20120325092533.GA13307@liondog.tnic>
In-Reply-To: <20120325092533.GA13307@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2012 02:25 AM, Borislav Petkov wrote:
> 
>> /*
>>  * findcpio.c
>>  *
>>  * Find a specific cpio member; must precede any compressed content.
> 
> Looks simple enough. Btw, there's some cpio handling already done in
> <init/initramfs.c> - probably reuse some of the code there...?
> 

Quite possible, but then you will have to untangle the dependencies.
Keep in mind that it needs to be able to compile this in such a way that
you have no library dependencies and no fixed address references (so
that it can be invoked from the pre-paging code to get microcode updates
in as early as at all possible.)  So code reuse is a bit tricky at least
for that specific use case.  The ACPI code is less sensitive since it
comes a lot later.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

