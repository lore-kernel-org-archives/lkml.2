Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0LHJNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:13:41 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36805 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab0LHJNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:13:39 -0500
X-Greylist: delayed 1158 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 04:13:38 EST
Message-ID: <4CFF47A0.8010208@atmel.com>
Date: Wed, 08 Dec 2010 09:53:52 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        linux@arm.linux.org.uk, costa.antonior@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com> <4CFE90CA.9050004@bluewatersys.com>
In-Reply-To: <4CFE90CA.9050004@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

Le 07/12/2010 20:53, Ryan Mallon :
> On 12/08/2010 03:42 AM, Igor Plyatov wrote:
>> * The gms is a board from GeoSIG Ltd company.
>>   It is based on the Stamp9G20 module from Taskit company.
>> * This is a second version of the patch with adjustments according
>>   to comments from Ryan Mallon.
>> * This patch made for Linux 2.6.37-rc5.

First thank you for submitting this board support.

>> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
>> ---

[..]

> Couple more comments below.
> Looking at this a bit more closely, the Stamp9G20 is a system on module
> (SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
> taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
> on the PControl carrier board. There is a reasonable amount of code
> replication in each of the board files for the UARTs, NAND, MMC, etc.
> 
> Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
> core support for the Stamp9G20 module and then each of the carrier board
> files contain only the setup/devices found on the carrier board?

I have exactly the same feeling as Ryan. We should make sure 
to factorize as much code as possible for maintenance reasons.

If you need to distinguish between board features, you can 
pass information in system_rev as implemented in this 
board merging commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6e016f19d393fbe4e040bee8155b03b840fa689

Best regards,
-- 
Nicolas Ferre
