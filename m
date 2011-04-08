Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1DHRYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:24:52 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2579 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1DHRYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:24:51 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop>
 <BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
Date: Fri, 8 Apr 2011 19:24:33 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtmqm7fw3ri7v4@arend-laptop>
In-Reply-To: <BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61819A0E3I88239603-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Apr 2011 18:56:13 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/4/6 Arend van Spriel <arend@broadcom.com>:
>> 3. Device identification
>>
>> The cores are identified by manufacturer, core id and revision in your
>> patch. I would not use the revision because 4 out of 5 times a revision
>> change does indicate a hardware change but no change in programming
>> interface. The enumeration data does contain a more selective field
>> indicating the core class (4 bits following the core identifier). I  
>> suggest
>> to replace the revision field by this class field.
>
> Could you say something more about *class*, please? For my BCM43224 it
> seems to be 0x0. WIll check BCM4313 in a moment.
>

In principal the manufacturer id is unique (defined/assigned by JEDEC  
www.jedec.org) and the chip id and chip class are defined by the  
manufacturer. So I can only indicate what classes Broadcom uses in  
combination with the manufacturer id BRCM, ARM and MIPS.

/* Component Classes */
#define	CC_SIM			0
#define	CC_EROM			1
#define	CC_CORESIGHT		9
#define	CC_VERIF		0xb
#define	CC_OPTIMO		0xd
#define	CC_GEN			0xe
#define	CC_PRIMECELL		0xf

Looking at this it seems strange that you see a class value of 0x0. It may  
be rarely used or for non-production chips only (for simulation, chip  
bringup) which may require additional (debug) functions. So question is  
whether you will need it, but it is specified by ARM and it is up to  
manufacturers to use it. So I it is better to be safe than sorry and have  
this in the device id.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

