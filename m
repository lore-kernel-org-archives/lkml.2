Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0HBSYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:24:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0HBSYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:24:49 -0400
Message-ID: <4C570CDD.5070304@zytor.com>
Date: Mon, 02 Aug 2010 11:22:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@hera.kernel.org>
CC: torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, pjones@redhat.com, lenb@kernel.org,
        michaelc@cs.wisc.edu
Subject: Re: [GIT PULL] iBFT features for v2.6.36
References: <20100802143642.GA15428@hera.kernel.org>
In-Reply-To: <20100802143642.GA15428@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 07:36 AM, Konrad Rzeszutek wrote:
> What is iBFT?
> The iBFT is an equivalent to the Boot Flag, except that its geared
> towards iSCSI and hence requires much more information (such as
> the IP of target, passwords, which device to login, etc). iBFT
> is a data structure populated by the BIOS or the NIC to contain this
> so that the OS can read it and login to the iSCSI and present
> the boot device to the initrd for mounting / FS.

I really don't see iBFT as equivalent to the boot flag at all.  The boot
flag returns the status of the previous boot attempt; iBFT contains
information about where to find the current root.

Unfortunately, we're increasingly seeing a proliferation of this kind of
nonstandard ACPI tables, because it is difficult to add data to ACPI at
runtime.  gPXE creates an aBFT table for AoE and sBFT for SRP, and
memdisk uses mBFT for MEMDISK at the moment.

It would be good to have some kind of common structure framework for these.

	-hpa
