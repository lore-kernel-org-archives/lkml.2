Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2FEUyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:54:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50726 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2FEUyp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE5AD1.6040705@gmx.de>
References: <1337013111-7732-1-git-send-email-tartler@cs.fau.de> <4FCE5AD1.6040705@gmx.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jun 2012 04:54:23 +0800
Message-ID: <CAMPhdO-s0h7ttnApv4ZE++XeOSfOdwh6n-F1dwOhL0qcpmSTGA@mail.gmail.com>
Subject: Re: [PATCH] mbxfb: unbreak compilation with CONFIG_FB_MBX_DEBUG
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: tartler@cs.fau.de, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de, Reinhard Tartler <siretart@tauware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 3:15 AM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> Hi,
>
> On 05/14/2012 04:31 PM, tartler@cs.fau.de wrote:
>> From: Reinhard Tartler <siretart@tauware.de>
>>
>> This patch adds missing function prototypes.
>>
>> Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
>> ---
>>  drivers/video/mbx/mbxfb.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> This patch was found with tools developed in the VAMOS project:
>> http://www4.cs.fau.de/Research/VAMOS/
>>
>> TBH, I'm not sure if this is the correct solution. However, I'd
>> appreciate if someone could confirm that this is a real bug.
>>
>>
>> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
>> index 6ce3416..c2200ec 100644
>> --- a/drivers/video/mbx/mbxfb.c
>> +++ b/drivers/video/mbx/mbxfb.c
>> @@ -878,6 +878,9 @@ static int mbxfb_resume(struct platform_device *dev)
>>  #ifndef CONFIG_FB_MBX_DEBUG
>>  #define mbxfb_debugfs_init(x)        do {} while(0)
>>  #define mbxfb_debugfs_remove(x)      do {} while(0)
>> +#else
>> +void mbxfb_debugfs_init(struct fb_info *fbi);
>> +void mbxfb_debugfs_remove(struct fb_info *fbi);
>
> I don't agree. checkpatch complains
> WARNING: externs should be avoided in .c files
> #71: FILE: drivers/video/mbx/mbxfb.c:882:
> +void mbxfb_debugfs_init(struct fb_info *fbi);
>
> And in drivers/video/mbx/mbxdebugfs.c
> static void __devinit mbxfb_debugfs_init(struct fb_info *fbi)
> static void __devexit mbxfb_debugfs_remove(struct fb_info *fbi)
>
> So even if you want to ignore the checkpatch warning (which I could
> understand for just 2 includes even if headers are certainly better)
> you'd have to remove the static at the implementation and for
> consistency include the __devinit/exit in your prototypes.

That actually made a very good point, and I seriously doubt whether the
mbxfb_debugfs_* thing has ever been tested. Instead of making them
public, I see a chance maybe we could remove them completely instead.

>
>>  #endif
>>
>>  #define res_size(_r) (((_r)->end - (_r)->start) + 1)
>
>
> Best regards,
>
> Florian Tobias Schandinat
