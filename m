Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2IDRAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:00:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2IDRAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:00:49 -0400
Message-ID: <50463399.70506@zytor.com>
Date: Tue, 04 Sep 2012 10:00:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org, robert.moore@intel.com,
        Fenghua Yu <fenghua.yu@intel.com>, initramfs@vger.kernel.org,
        bigeasy@linutronix.de, vojcek@tlen.pl, eric.piel@tremplin-utc.net,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 1/2] lib: Add early cpio decoder
References: <1346318957-5831-1-git-send-email-trenn@suse.de> <1346318957-5831-2-git-send-email-trenn@suse.de>
In-Reply-To: <1346318957-5831-2-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 02:29 AM, Thomas Renninger wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
>
> Add a simple cpio decoder without library dependencies for the purpose
> of extracting components from the initramfs blob for early kernel
> uses.  Intended consumers so far are microcode and ACPI override.
>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> CC: Thomas Renninger <trenn@suse.de>
> Link: http://lkml.kernel.org/r/201203261651.29640.trenn@suse.de
> Signed-off-by: Thomas Renninger <trenn@suse.de>

I was trying to figure out if there is a way to do what you want 
(support for multiple files) without the problems of the callback 
interface.  I think it is actually fairly straightforward; we need a 
prefix iterator (so you can give it a string like "kernel/acpi/" rather 
than a full filename) and it needs to be able to accept a "last" pointer 
so it can resume scanning at the point it last left off.  That should be 
a pretty trivial change.

The other thing we presumably want to do -- and this is generic -- is to 
be able to handle multiple sources for the initramfs; at the very least 
there is built in vs provided from the boot loader.  I had originally 
intended to just handle that by calling the earlycpio function once per 
block, but the "last left off" bit makes that a little harder.  Need to 
think about that a little bit.

I am guessing that this may not need to be something we need from the 
very beginning, or am I wrong?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

