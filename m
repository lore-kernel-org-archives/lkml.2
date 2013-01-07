Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3AGJbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:31:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:54516 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3AGJbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:31:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="268544351"
Message-ID: <50EA95FC.2020103@intel.com>
Date: Mon, 07 Jan 2013 17:31:40 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 4/4] sd: change to auto suspend mode
References: <1357461697-4219-1-git-send-email-aaron.lu@intel.com> <1357461697-4219-5-git-send-email-aaron.lu@intel.com> <2040976.slu5Ii8g67@linux-5eaq.site>
In-Reply-To: <2040976.slu5Ii8g67@linux-5eaq.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 05:19 PM, Oliver Neukum wrote:
> On Sunday 06 January 2013 16:41:37 Aaron Lu wrote:
>> From: Lin Ming <ming.m.lin@intel.com>
>>
>> Uses block layer runtime pm helper functions in
>> scsi_runtime_suspend/resume.
>> Remove scsi_autopm_* from sd open/release path and check_events path.
>> And remove the quiesce call in runtime suspend path, as we know there is
>> no request to quiesce for the device.
> 
> How does this handle ioctl() ?

The ioctl code will allocate a new request and execute it through block
layer API, which involves adding the request to the queue and releasing
it when it is finished.

Thanks,
Aaron

