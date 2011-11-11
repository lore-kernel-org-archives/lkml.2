Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1KKJ51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:57:27 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:37100 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1KKJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:57:20 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EBCF17E.9070601@cam.ac.uk>
Date: Fri, 11 Nov 2011 09:57:18 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: oskar.andero@sonyericsson.com
CC: Jonathan Cameron <jic23@kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH] input: add driver support for Sharp gp2ap002a00f proximity
 sensor
References: <1320941273-21228-1-git-send-email-oskar.andero@sonyericsson.com> <4EBC1668.5040606@kernel.org> <20111111090616.GA9307@caracas.corpusers.net>
In-Reply-To: <20111111090616.GA9307@caracas.corpusers.net>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 09:06 AM, oskar.andero@sonyericsson.com wrote:
> Hi Jonathan,
> 
> Thanks for reviewing!
> 
>> ALS sensor in input?  Please see all the previous discussions about
>> this.  I'm guessing you are aware of this given you cc'd me though!
> 
> Actually, this chip only has a hardwired ALS, meaning nothing is
> exposed through the input interfaces.
> 
>> Having read driver, this is a proximity switch. Basically it's a button.
>> The interface used should reflect this rather than pretending you are
>> outputing an ABS value.  Hence this one probably does fit squarely in
>> input, but that's for Dmitry to comment on.
> 
> Yes, I agree.
> 
>> Also, irq fields contain irqs not gpios + the two gpio related pdata
>> functions need justification.
>>
>> Various small points inline.
> 
>>> --- /dev/null
>>> +++ b/include/linux/gp2ap002a00f.h
>>> @@ -0,0 +1,13 @@
>>> +#ifndef _GP2AP002A00F_H_
>>> +#define _GP2AP002A00F_H_
>>> +
>> What is this doing in the header?
>>> +#define GP2A_I2C_NAME   "gp2ap002a00f"
> 
> This is used for setting up the I2C_BOARD_INFO() in the board file. I
> grepped linux/input and found some other drivers doing the same, but if this
> is not common practice I can of course move the define to the .c-file.
> 
Fair enough.  I'm personally a  bit unclear what the advantage in doing
it this way is rather than just putting the string in directly but it
isn't important!
> I'll prepare v2 based on the rest of your comments!
> 
> Thanks!
> 
> -Oskar

