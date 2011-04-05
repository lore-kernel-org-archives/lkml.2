Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1DERrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:47:39 -0400
Received: from smtp.nokia.com ([147.243.128.26]:25694 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DERrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:47:36 -0400
Message-ID: <4D9B55A1.1080002@nokia.com>
Date: Tue, 5 Apr 2011 20:47:13 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: gadget: f_mass_storage: Prevent NULL pointer
 dereference
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com> <1302017802-16614-4-git-send-email-roger.quadros@nokia.com> <op.vtg2kx0d3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vtg2kx0d3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 05 Apr 2011 17:47:19.0834 (UTC) FILETIME=[82C06FA0:01CBF3B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 06:56 PM, ext Michal Nazarewicz wrote:
> On Tue, 05 Apr 2011 17:36:40 +0200, Roger Quadros
> <roger.quadros@nokia.com> wrote:
>> Prevent a NULL pointer dereference in fsg_config_from_params() if
>> 'file' parameter is not specified.
> 
> Have you observed this behaviour?  I don't see how it could happen with
> module parameters and if it appears in some gadget it's a bug in the

It can happen if the gadget that uses f_mass_storage specifies
file_count=1 and doesn't specify a file name.

> gadget.  Not that I'm saying checking for null pointer is a bad idea.

OK. let's do that then.

> 
>> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
>> ---
>>  drivers/usb/gadget/f_mass_storage.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_mass_storage.c
>> b/drivers/usb/gadget/f_mass_storage.c
>> index 5d7de93..f6bd001 100644
>> --- a/drivers/usb/gadget/f_mass_storage.c
>> +++ b/drivers/usb/gadget/f_mass_storage.c
>> @@ -3177,7 +3177,7 @@ fsg_config_from_params(struct fsg_config *cfg,
>>          lun->removable = /* Removable by default */
>>              params->removable_count <= i || params->removable[i];
>>          lun->filename =
>> -            params->file_count > i && params->file[i][0]
>> +            params->file_count > i && params->file[i]
> 
> You're removing the check if an empty file name has been specified.  It
> should read:
> 
> +            params->file_count > i && params->file[i] &&
> params->file[i][0]

Right.

> 
> And since the line is getting pretty long, maybe convert it to a proper
> “if”.  I'm sure Greg will like that. ;)
> 
>>              ? params->file[i]
>>              : 0;
>>      }
> 
ok.

-- 
regards,
-roger
