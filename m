Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2JBVul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:50:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab2JBVuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:50:40 -0400
Message-ID: <506B6191.6080605@zytor.com>
Date: Tue, 02 Oct 2012 14:50:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: T Makphaibulchoke <tmac@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        akpm@linux-foundation.org, yinghai@kernel.org, tiwai@suse.de,
        viro@zeniv.linux.org.uk, aarcange@redhat.com, tony.luck@intel.com,
        mgorman@suse.de, weiyang@linux.vnet.ibm.com,
        octavian.purdila@intel.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an efi
 machine
References: <1349213536-3436-1-git-send-email-tmac@hp.com>
In-Reply-To: <1349213536-3436-1-git-send-email-tmac@hp.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 02:32 PM, T Makphaibulchoke wrote:
> Changing devmem_is_allowed so that on an EFI machine, access to physical
> address below 1 MB is allowed only to physical pages that are valid in
> the EFI memory map.  This prevents the possibility of an MCE due to
> accessing an invalid physical address.

What?

That sounds like exactly the opposite of normal /dev/mem behavior... we
allow access to non-memory resources (which really could do anything if
misused), but not memory.

You seem like you're flipping it on its head.

	-hpa

