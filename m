Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0ISMbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:31:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0ISMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NI5o+7GKykYBkPvGC8oVgR3+RPCR7H4taqDwkw7idcKjzHLp6Ru7i4BWcPZ5gdCdC2
         o1y/fcS4Nlqp2CqSLR1ZHL2mqfnMRkw1ZOgR/eK3tPYIE9y6D45pIdAI9WP3L99ZR5V+
         4B9I2r6H+dCpICNBd/YKtm9MqI+Wawz9Qf8Zw=
Message-ID: <4C9602E4.4090007@gmail.com>
Date: Sun, 19 Sep 2010 14:32:36 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pedro Francisco <pedrogfrancisco@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: ahci rmmodable and shouldn't
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net> <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2>
In-Reply-To: <1284892106.2650.4.camel@sundae-v2>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/19/2010 12:28 PM, Pedro Francisco wrote:
> On Sex, 2010-09-17 at 11:53 +0200, Tejun Heo wrote:
>> Just don't rmmod a module which is serving a live filesystem.  Why
>> does it even matter?
> 
> ... Ok, let me argue another way. What if my mail was called: «lsmod
> shows false values ("Used by: 0") for module 'ahci'», would you agree it
> was an error and should therefore be fixed?

I think it works the same way for any other SCSI driver and it's
pretty convenient during development.  You can unload any network
driver module while the network is still up too.  Module reference
count doesn't have any specific meaning of 'use' preassigned other
than it's there to prevent unloading module while the code and data
are being actively used by the processor.  It's unfortunate that the
way module reference count is used for libata is causing discomfort to
you but I need much better reason to change it.

Thanks.

-- 
tejun
