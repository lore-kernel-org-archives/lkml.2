Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1GVAd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:33:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:14683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1GVAdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,244,1309762800"; 
   d="scan'208";a="33234932"
Message-ID: <4E28C552.8060803@intel.com>
Date: Fri, 22 Jul 2011 08:33:22 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pstore: change mutex locking to spin_locks
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com> <4E277584.1060200@intel.com> <20110721122731.GV3765@redhat.com> <987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 01:57 AM, Luck, Tony wrote:
>>> Is it safe to call pstore_mkfile with IRQ disabled?
>>>
>>> pstore_mkfile -> d_alloc_name -> d_alloc -> kmem_cache_alloc(, GFP_KERNEL).
>>
>> Don't know.  But would that mean we would have to put the pstore_mkfile
>> on a workqueue then or something similar?
> 
> That might be a good idea anyway.  In the "oops" case we'd like the file
> to appear in the pstore filesystem if the system stayed healthy despite
> the oops[1]. There isn't any reason why the pstore entry must appear instantly.
> Delaying the creation would avoid running into problems related to the
> oops.

For oops, it may be better to delay writing into something like
workqueue.  But for panic, I think we should write the record to backend
(such as ERST) as soon as possible.  So maybe it is better to write to
backend as soon as possible and delay writing to pstore filesystem.

Best Regards,
Huang Ying
