Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2JCEcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:32:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39988 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2JCEb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:31:59 -0400
Date: Wed, 3 Oct 2012 05:31:17 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: T Makphaibulchoke <tmac@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, yinghai@kernel.org,
        tiwai@suse.de, viro@zeniv.linux.org.uk, aarcange@redhat.com,
        tony.luck@intel.com, mgorman@suse.de, weiyang@linux.vnet.ibm.com,
        octavian.purdila@intel.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an
 efi machine
Message-ID: <20121003043116.GA26241@srcf.ucam.org>
References: <1349213536-3436-1-git-send-email-tmac@hp.com>
 <506B6191.6080605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506B6191.6080605@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 02:50:09PM -0700, H. Peter Anvin wrote:

> That sounds like exactly the opposite of normal /dev/mem behavior... we
> allow access to non-memory resources (which really could do anything if
> misused), but not memory.

>From arch/x86/mm/init.c:

 * On x86, access has to be given to the first megabyte of ram because that area
 * contains bios code and data regions used by X and dosemu and similar apps.

Limiting this to just RAM would be safer than it currently is. I'm not 
convinced that there's any good reason to allow *any* access down there 
for EFI systems, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
