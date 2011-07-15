Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1GOJBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:01:39 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:39782 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1GOJBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:01:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E2001F0.4050402@cam.ac.uk>
Date: Fri, 15 Jul 2011 10:01:36 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
References: <20110709044923.GB13074@opensource.wolfsonmicro.com> <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com> <20110715025327.GI2927@ponder.secretlab.ca> <20110715043922.GJ32716@opensource.wolfsonmicro.com> <CACxGe6sjTTnB2_e2omp51bnc+4kshkhNRfqDPdB3fYQG=oiWmQ@mail.gmail.com> <20110715050939.GM32716@opensource.wolfsonmicro.com>
In-Reply-To: <20110715050939.GM32716@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/11 06:09, Mark Brown wrote:
> On Thu, Jul 14, 2011 at 11:04:27PM -0600, Grant Likely wrote:
>> On Thu, Jul 14, 2011 at 10:39 PM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
> 
> [Regmap API I2C bus code.]
>>> There was a bit about this in the cover mail - it's the interace
>>> stability issue again, the plan is to move them once we're more
>>> confident that the interface used will stay stable.
> 
>> I've got no problem with churn in drivers/spi, and I'm fine to have
>> changes in drivers/spi merged via other trees if it means the code is
>> in the logical place.
> 
> Can I add an ack from you for that?  If/when it does get merged I'd
> appreciate it if you pushed any code to me for review.
> 
>>>>       struct spi_transfer t[2] = { {.tx_buf = reg, .len = reg_len},
>>>>                                    {.tx_buf = val, .len = val_len}};
> 
>>>> Then the memset() and t[0]/t[1] lines can all be culled.
> 
>>> That does the init to zero?
> 
>> You might want to double check, but I believe it gets implemented as a
>> memcpy of a static initializer.
> 
> Hrm, given that neither of us is 100% sure I think it's safer to leave
> it written out long hand and avoid confusing anyone else.

It does the init to zero. The relevant bit of the spec is designated initializers.

See c99 spec (draft here as I'm not paying for it ;) WG14/N1124
6.7.8 

Clause 19: The initialization shall occur in initializer list order, each initializer provided for a
particular subobject overriding any previously listed initializer for the same subobject;130)
all subobjects that are not initialized explicitly shall be initialized implicitly the same as
objects that have static storage duration.

So here they will be initialized the same as static objects. For completeness that's
covered in clause 10:
If an object that has automatic storage duration is not initialized explicitly, its value is
indeterminate. If an object that has static storage duration is not initialized explicitly,
then:
— if it has pointer type, it is initialized to a null pointer;
— if it has arithmetic type, it is initialized to (positive or unsigned) zero;
— if it is an aggregate, every member is initialized (recursively) according to these rules;
— if it is a union, the first named member is initialized (recursively) according to these
rules.


Jonathan
