Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1IOFV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 01:21:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1IOFVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 01:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110914232706.GB2953@opensource.wolfsonmicro.com>
References: <CAM8FrKKEXUwV6=cMzqi0Le7eadb2XWkrjSQ+jm=QBUJMGPKztQ@mail.gmail.com>
	<20110914232706.GB2953@opensource.wolfsonmicro.com>
Date: Thu, 15 Sep 2011 07:21:24 +0200
Message-ID: <CAM8FrKJbf-FhBrEs+YScF3rZFSa4_vzPAbaFP+2hB2qjXGSmNg@mail.gmail.com>
Subject: Re: Regulator constraints and userspace consumer
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Sep 14, 2011 at 08:54:47PM +0200, Marcus Folkesson wrote:
>
>>   What is the most accurate way to set the voltage for these
>> limitations when the system starts up? There is apparently no check if
>> the default configuration is within limits as the regulator stays on
>> 1125mV.
>>   When I'm looking in the userspace consumer (/sys/class/regulator/),
>> the "max_microvolts" and "min_microvolts" is set to 1000000 but the
>> "microvolts" is set to 1125000.
>
> Set apply_uV in hte constraints.  The regulator framework won't touch
> the hardware unless explicitly told to.


Ok, thank you!


>> * I want to change the output voltage from userspace on demand. What
>> is the most proper way to do this? If I have understand correctly, the
>> userspace consumer just exports interface for switching on/off the
>> regulator, is that correct?
>
> Why do you wish to do this?  In general this is not a good sign.  There
> is the virtual consumer but that is explicitly intended for test, it's
> not really supposed to be used in production.



We are working on an Software Defined Radio (SDR) in which power
consumption is an important part of the product.
The "modem" application executes in user space and has the
responsibility to turn the voltage regulators on/off to the radio card
and so on.
When the application goes into power-down mode, there are circuits
that are not used and we are able to reduce the voltage further by set
down a few boost regulators.
