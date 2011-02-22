Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1BVUwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:52:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:17989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1BVUwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XQdBPm7pbO8eUvgGOUCB4Q2hY3y2EZsNCFCrPLhilmzOWPhRNELhrcW3uQpdp5Q2k2
         9yL5hSIAezzJeCIRCHGg==
MIME-Version: 1.0
In-Reply-To: <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	<1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	<4D5DC289.1090004@codeaurora.org>
	<1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
Date: Tue, 22 Feb 2011 12:47:14 -0800
X-Google-Sender-Auth: ZlHnhKSNNNyF0Ghlip6PyTSC26U
Message-ID: <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
From: Dima Zavin <dima@android.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        davidb@codeaurora.org, tsoni@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:46 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Thu, 2011-02-17 at 16:51 -0800, Bryan Huntsman wrote:
>> On 02/17/2011 04:37 PM, Daniel Walker wrote:
>> > Can you put this in drivers/ this doesn't looks like it need to be here.
>>
>> Where would you suggest?  The initial attempt to model SSBI as an I2C
>> bus didn't go anywhere.  See http://lkml.org/lkml/2010/7/21/400.  This
>> functionality is specific to MSM.  Plus, we're trying to maintain
>> similarity to the Android MSM tree.  That may not matter to people who
>> don't use MSM, but is matters to us.  Given these considerations, the
>> current location seems as good a place as any.
>
> I don't know the driver well enough to be more detailed than suggesting
> drivers/ . In the thread you quoted Pavel (who I added to the CC line)
> suggested drivers/ssbi/ .

I'm not sure that knowing the driver would help. SSBI is a Qualcomm
proprietary protocol that will only ever have one ssbi "host" driver
in it. The slave is always the PMIC (maybe the audio codec too, but
that's normally speaking i2c even in qualcomm's case). The slave PMIC
drivers, however, will go under drivers/mfd for the core and the
peripheral drivers into the appropriate drivers/xxx/ dirs, just like
all the other pmic drivers. The audio codec would go into
sound/soc/codecs. Thus, adding drivers/ssbi/ to just house ssbi.c
doesn't really make sense to me.

What is the problem leaving it under arch/arm/mach-msm?

--Dima
