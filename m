Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0ITG2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:28:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33251 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0ITG2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :x-antivirus:x-antivirus-status;
        b=ZEbFLGvmPAvbw1TcmLF6mEcj50XnLvJf8wxQbDU9TOj36b1wcCErssfQKIT1Sx5QZs
         UtMRpcnU5/LLzOefuBLSoCJUcdbd5N/U1RbTDTuBSuJ2fA04K5fdODpiGtvYsI32vUCX
         G9JsoehDobNgYLvVzadGaEp0pWLecnTtideHk=
Message-ID: <4C96FF10.2010805@gmail.com>
Date: Sun, 19 Sep 2010 23:28:32 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v4] mtd: nand: Expand nand_ecc_layout, deprecate ioctl
 ECCGETLAYOUT
References: <4C5CA4A1.1040000@broadcom.com>	 <1282154806-9420-1-git-send-email-norris@broadcom.com>	 <4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com>	 <1282646703.24044.162.camel@localhost>  <4C746DE0.7000104@gmail.com>	 <1283163647.12995.43.camel@brekeke> <1284830690.1721.3.camel@brekeke>
In-Reply-To: <1284830690.1721.3.camel@brekeke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 100919-1, 09/19/2010), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Now that I've finally gotten around to working on this, I have questions
and comments.

On 9/18/2010 10:24 AM, Artem Bityutskiy wrote:
> On Mon, 2010-08-30 at 13:20 +0300, Artem Bityutskiy wrote:
>> On Tue, 2010-08-24 at 18:12 -0700, Brian Norris wrote:
>>> My e-mail address has changed, since I am no longer working at Broadcom.
>>> I will still be able to track messages to my old account if the MTD mailing
>>> list is CC'd.
>>
>> Oh, does it mean you will stop loving MTD and we won't see steady flow
>> of improvements for you? :-( BTW, I think you have been doing great job
>> - MTD subsystem needs love badly!

No, this doesn't mean I will stop loving MTD, although as may be readily
apparent by my delay, I may work a bit slower :) In fact, I will
probably be picking up some more work shortly.

>>> +/*
>>> + * Copies (and truncates, if necessary) data from the larger struct,
>>> + * nand_ecclayout, to the smaller, deprecated layout struct,
>>> + * nand_ecclayout_user. This is necessary only to suppport the deprecated
>>> + * API ioctl ECCGETLAYOUT while allowing all new functionality to use
>>> + * nand_ecclayout flexibly (i.e. the struct may change size in new
>>> + * releases without requiring major rewrites).
>>> + */
>>
>> I think a similar comment should exist in linux/mtd/mtd.h. Indeed, that
>> file is our API with user-space, and our users will probably look at it,
>> and it is nice to document the situation with 'struct
>> nand_ecclayout_user' there.

>From the context, I assume you meant include/mtd/mtd-abi.h, not
linux/mtd/mtd.h; am I correct?

I will send the patch out shortly under the assumption that I am correct.

Brian
