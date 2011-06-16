Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1FPJio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:38:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53789 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1FPJin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WkpYD98opLSqvqb+mWdWQ/zadCoX+avWl4cdJS3ZHE+tUoBCs+1/QoQFlvoEtBWYN5
         aCA1CL0O8VryJ1VCKy/sxGNiTfUUcKKqPKQ7rdStyhxlDt/9F9Fyv77JTAzeTzouSa8i
         BRst73y43iQSqs/24kaf+0Y27DFbEvvzng7rI=
MIME-Version: 1.0
In-Reply-To: <BANLkTinfNKKeyC9RB-uvFSVq5OeNXiw95Q@mail.gmail.com>
References: <20110616110256.0890dd37@susi.home.s3e.de>
	<BANLkTinfNKKeyC9RB-uvFSVq5OeNXiw95Q@mail.gmail.com>
Date: Thu, 16 Jun 2011 11:38:41 +0200
Message-ID: <BANLkTimBrsSoYi-Cqr3DhbTQO0iCBEEuJg@mail.gmail.com>
Subject: Re: 3.0-rc2: mei breaks suspend
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Oren Weil <oren.jer.weil@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/16 Maarten Lankhorst <m.b.lankhorst@gmail.com>:
> Hi Stefan,
>
> 2011/6/16 Stefan Seyfried <stefan.seyfried@googlemail.com>:
>> Hi,
>>
>> having the "mei" driver loaded, which happened automatically on my
>> ThinkPad X200s, successfully prevents any suspend efforts:
>>
>> [39736.728116] pci_pm_suspend(): mei_pci_suspend+0x0/0xc0 [mei] returns 9999
>>
>> The code has not changed since 3.0-rc2, so I did not try compiling latest
>> git.
>>
>> Jiri Slaby hinted that this code in drivers/staging/mei/wd.c is to blame:
>>
>> 169         ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
>> 170                                         dev->wd_stopped, 10 * HZ);
>>
>> I am, however, not familiar enough with timers and stuff to immediately
>> spot the problem.
>>
>> Removing the module before suspend is a workaround.
>>
>> This could be considered a regression, as suspend worked very well before
>> this driver was introduced :-)
Nm, stupid suggestion.

Adding the author to cc, maybe he knows.
