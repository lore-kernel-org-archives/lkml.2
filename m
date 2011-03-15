Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab1COP6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:58:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53215 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1COP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:58:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="80064449"
Message-ID: <cabe5c85f32b7eb41504225acfcc87df.squirrel@www.codeaurora.org>
In-Reply-To: <4D7EC274.4020407@codeaurora.org>
References: <1299608733-28514-1-git-send-email-sheetals@codeaurora.org>
    <1299691007-13470-1-git-send-email-sheetals@codeaurora.org>
    <4D7EC274.4020407@codeaurora.org>
Date: Tue, 15 Mar 2011 08:58:31 -0700 (PDT)
Subject: Re: [PATCH v4 2/3] [ARM] perfevents: Add support for Scorpion 
     performance monitors
From: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>
To: will.deacon@arm.com, jean.pihet@newoldbits.com,
        "Bryan Huntsman" <bryanh@codeaurora.org>
Cc: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, jamie.iles@picochip.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will/Jean,

On Mon, March 14, 2011 6:35 pm, Bryan Huntsman wrote:
> On 03/09/2011 09:16 AM, Sheetal Sahasrabudhe wrote:
>> This commit adds support for performance monitors provided by
>> Qualcomm Scorpion and ScorpionMP processor to perfevents.
>>
>> Signed-off-by: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
>> Reviewed-by: Jean Pihet <j-pihet@ti.com>
>> Reviewed-by: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm/include/asm/perf_event.h |    2 +
>>  arch/arm/kernel/perf_event.c      |   11 +
>>  arch/arm/kernel/perf_event_msm.c  |  679 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 692 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/kernel/perf_event_msm.c
>>
>
> ...
>
>> diff --git a/arch/arm/kernel/perf_event_msm.c b/arch/arm/kernel/perf_event_msm.c
>> new file mode 100644
>> index 0000000..4e42f27
>> --- /dev/null
>> +++ b/arch/arm/kernel/perf_event_msm.c
[...]

>> +#include <asm/vfp.h>
>> +#include <asm/system.h>
>> +#include "../vfp/vfpinstr.h"
>
> Sorry I didn't see this earlier.  Is there another way to get the info
> you need that wouldn't use a relative include path?  If the info from
> vfpinstr.h is now needed outside of the vfp directory, can it be moved
> to a common header instead?  Thanks.
>
> - Bryan

I see other files under vfp that include this header.
So if we were to implement Bryan's suggestion, I think a separate patch that moves the header and updates all the depdendencies would be more appropriate.
Are you okay with the relative include path for vfpinstr.h in this patch for now or would you want to see an update to move vfpinstr.h to include/asm?.

Thanks,
Sheetal

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



