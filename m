Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab0LTSdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:33:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0LTSdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lP//XC+awXUkhl688zEB7wssUD+KZiL/5oh3O41Y5yCJskhYxv6vMDrwQYYuoZ+p6z
         azUr/zDQUh8QObDqRN+sE26OyqQgOXsUBd70l8tIRxZbKHanjP6boNbhGWZ7O5Bwzc5o
         jkEckevo7Eo6YrXZc7aDXM6yorDsKDL36Uq6M=
MIME-Version: 1.0
In-Reply-To: <20101220190630.66084e1d@neptune.home>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 20 Dec 2010 13:32:44 -0500
Message-ID: <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
Subject: Re: Slow disks.
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 1:06 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi,
>
> [ccing linux-ide]
>
> Please provide the part of kernel log showing initialization of your
> disk controller(s) as well as detection of all the discs.
> Verbose lspci output for the disc controller and $(smartctl -i -A $disk)
> output might be useful as well.
>
> Did you try the individual discs on a completely different system (e.g.
> plain desktop system) and what revision of SATA are both components
> supporting?
>
> Bruno
>
>
> On Mon, 20 December 2010 Rogier Wolff <R.E.Wolff@BitWizard.nl> wrote:
>> Hi,
>>
>> A friend of mine has a server in a datacenter somewhere. His machine
>> is not working properly: most of his disks take 10-100 times longer
>> to process each IO request than normal.
>>
>> iostat -kx 10 output:
>> Device: rrqm/s wrqm/s r/s  w/s  rkB/s wkB/s avgrq-sz avgqu-sz await svctm %util
>> sdd     0.30   0.00   0.40 1.20 2.80  1.10  4.88     0.43  271.50 271.44  43.43
>>
>> shows that in this 10 second period, the disk was busy for 4.3 seconds
>> and serviced 15-16 requests during that time.
>>
>> Normal disks show "svctm" of around 10-20ms.
>>
>> Now you might say: It's his disk that's broken.
>> Well no: I don't believe that all four of his disks are broken.
>> (I just showed you output about one disk, but there are 4 disks in there
>> all behaving similar, but some are worse than others.)
>>
>> Or you might say: It's his controller that's broken. So we thought
>> too. We replaced the onboard sata controller with a 4-port sata
>> card. Now they are running off the external sata card... Slightly
>> better, but not by much.
>>
>> Or you might say: it's hardware. But suppose the disk doesn't properly
>> transfer the data 9 times out of 10, wouldn't the driver tell us
>> SOMETHING in the syslog that things are not fine and dandy? Moreover,
>> In the case above, 12kb were transferred in 4.3 seconds. If CRC errors
>> were happening, the interface would've been able to transfer over
>> 400Mb during that time. So every transfer would need to be retried on
>> average 30000 times... Not realistic. If that were the case, we'd
>> surely hit a maximum retry limit every now and then?
>>
>>
>> These syptoms started when the system was running 2.6.33, but are
>> still present now the system has been upgraded to 2.6.36.
>>
>> Is there anything you can suggest to get to the root of this problem?
>> Could this be a software issue with the driver? Can we enable some
>> driver debugging to find out what is wrong?
>>
>> Any help will be appreciated.
>>
>>       Roger.

My personal guess would definitely be hardware.  The only common
component I can think of is power.  SATA is very sensitive to
requiring high-quality power.  Much more so than IDE.

Greg
