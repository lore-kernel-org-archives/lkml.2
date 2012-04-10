Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2DJBQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:16:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:21200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab2DJBQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:16:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="130500659"
Message-ID: <4F8389A0.6020205@intel.com>
Date: Tue, 10 Apr 2012 09:15:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alex Shi <lkml.alex@gmail.com>
CC: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        roland@purestorage.com
Subject: Re: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
References: <1332742810-5116-1-git-send-email-alex.shi@intel.com> <CAGjg+kHjUcYEnszBE4RdbeU52Nao0jJa56JXk180aONMbn-JBA@mail.gmail.com>
In-Reply-To: <CAGjg+kHjUcYEnszBE4RdbeU52Nao0jJa56JXk180aONMbn-JBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 07:54 PM, Alex Shi wrote:

> Without the following patch, the driver will have many complain after
> smp_processor_id debug enabled.
> 
> So would you like consider to pick this patch or find a better way to
> remove them?


Anyone like to have a look on the following complain?

> 
> Call Trace:^M
>  [<ffffffff81325f77>] debug_smp_processor_id+0xe7/0x100^M
>  [<ffffffffa0016324>] mpt2sas_base_put_smid_default+0x34/0x70 [mpt2sas]^M
>  [<ffffffffa0016472>] _base_event_notification+0x112/0x240 [mpt2sas]^M
>  [<ffffffffa0016a11>] _base_make_ioc_operational+0x471/0x1240 [mpt2sas]^M
>  [<ffffffff810b9963>] ? lockdep_init_map+0xa3/0x560^M
>  [<ffffffff810be4fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0^M
>  [<ffffffff810b8588>] ? debug_mutex_init+0x38/0x50^M
>  [<ffffffffa00193c7>] mpt2sas_base_attach+0x1237/0x1630 [mpt2sas]^M
>  [<ffffffffa001ecf8>] _scsih_probe+0x408/0x620 [mpt2sas]^M
>  [<ffffffff8133c64c>] local_pci_probe+0x5c/0xd0^M
>  [<ffffffff8133df41>] pci_device_probe+0x101/0x120^M
>  [<ffffffff814190dc>] driver_probe_device+0x9c/0x300^M
>  [<ffffffff814193eb>] __driver_attach+0xab/0xb0^M
>  [<ffffffff81419340>] ? driver_probe_device+0x300/0x300^M
>  [<ffffffff8141747e>] bus_for_each_dev+0x5e/0x90^M
>  [<ffffffff81418cee>] driver_attach+0x1e/0x20^M
>  [<ffffffff814188e0>] bus_add_driver+0x1c0/0x2b0^M
> 


