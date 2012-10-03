Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2JCFiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:38:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab2JCFiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:38:21 -0400
Message-ID: <506BCEAB.4090204@zytor.com>
Date: Tue, 02 Oct 2012 22:35:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        T Makphaibulchoke <tmac@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, yinghai@kernel.org,
        tiwai@suse.de, viro@zeniv.linux.org.uk, aarcange@redhat.com,
        tony.luck@intel.com, mgorman@suse.de, weiyang@linux.vnet.ibm.com,
        octavian.purdila@intel.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an efi
 machine
References: <1349213536-3436-1-git-send-email-tmac@hp.com> <506B6191.6080605@zytor.com> <20121003043116.GA26241@srcf.ucam.org> <506BC2A0.8060500@zytor.com> <20121003051522.GA27113@srcf.ucam.org> <506BC96D.10507@hp.com> <20121003052803.GA27464@srcf.ucam.org>
In-Reply-To: <20121003052803.GA27464@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 10:28 PM, Matthew Garrett wrote:
> On Tue, Oct 02, 2012 at 11:13:17PM -0600, Thavatchai Makphaibulchoke wrote:
> 
>> Sounds like a better solution is to allow accesses to only I/O regions 
>> presented in the EFI memory map for physical addresses below 1 MB.
> 
> That won't work - unfortunately we do still need the low region to be 
> available for X because some platforms expect us to use int10 even on 
> EFI (yes, yes, I know). Do you have a copy of the EFI memory map for a 
> system that's broken with the current code?
> 

I honestly think this calls for a quirk, or more likely, no action at
all ("don't do that, then.")

	-hpa


