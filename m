Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab0KQQHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:07:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0KQQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:07:13 -0500
Message-ID: <4CE3FD80.7010808@oracle.com>
Date: Wed, 17 Nov 2010 08:06:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: fix acpi/video.h error and warning when PM is not
 enabled
References: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com>	 <20101116165954.f7d8540b.randy.dunlap@oracle.com> <1289957348.8148.2098.camel@rui>
In-Reply-To: <1289957348.8148.2098.camel@rui>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/10 17:29, Zhang Rui wrote:
> On Wed, 2010-11-17 at 08:59 +0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> When CONFIG_PM is not enabled, acpi/video.h causes a build error.
>> Also fix a longstanding warning.
>>
>> include/acpi/video.h:22: warning: 'struct acpi_device' declared inside parameter list
>> include/acpi/video.h:22: warning: its scope is only this definition or declaration, which is probably not what you want
>> include/acpi/video.h: In function 'acpi_video_get_edid':
>> include/acpi/video.h:24: error: 'ENODEV' undeclared (first use in this function)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> we already have a patch at
> http://marc.info/?l=linux-kernel&m=128369371631933&w=2
> Not sure if Len has applied it or not.
> Anyway, thanks for the patch. :)

Good.  Thanks for the info.

> -rui
>> ---
>>  include/acpi/video.h |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> --- lnx-2637-rc2.orig/include/acpi/video.h
>> +++ lnx-2637-rc2/include/acpi/video.h
>> @@ -1,6 +1,10 @@
>>  #ifndef __ACPI_VIDEO_H
>>  #define __ACPI_VIDEO_H
>>  
>> +#include <linux/errno.h>
>> +
>> +struct acpi_device;
>> +
>>  #define ACPI_VIDEO_DISPLAY_CRT  1
>>  #define ACPI_VIDEO_DISPLAY_TV   2
>>  #define ACPI_VIDEO_DISPLAY_DVI  3
>> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
