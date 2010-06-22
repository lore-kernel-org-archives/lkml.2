Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab0FVX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:27:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2753 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0FVX1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Yk6AV6E4UhloPliHv+F0KEPdUs3SDwL4G43BkWThwrakgEAiV+BcsktMyASZADaodV
         HTWo0qUtjVHpmTK6gMuR5WEi4vell/dFyN82p4qz3kKsayceQAt9UGa+PR2LX5LKQQO7
         2FM3hHJzOxz3S0sgC5RHDP1KaW1TS6hCy0VbM=
From: Christoph Mair <christoph.mair@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Support for the pressure sensor BMP085 from Bosch Sensortec.
Date: Wed, 23 Jun 2010 01:26:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-ARCH; KDE/4.4.4; x86_64; ; )
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       linux-kernel@vger.kernel.org,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>
References: <4C1DF4DE.5090403@jic23.retrosnub.co.uk> <1277067058-6929-1-git-send-email-christoph.mair@gmail.com> <20100621144958.d5fc694e.akpm@linux-foundation.org>
In-Reply-To: <20100621144958.d5fc694e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006230126.48452.christoph.mair@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 21 Juni 2010, 23:49:58 schrieben Sie:
> On Sun, 20 Jun 2010 22:50:58 +0200
> 
> Christoph Mair <christoph.mair@gmail.com> wrote:
> > This driver adds support for the BMP085 digital pressure sensor
> > from Bosch Sensortec.
> 
> If there's a datasheet available, it would be nice to provide a
> reference to that in the driver.
I will send a patch to fix this.

> Please do send a full description of the proposed API so we can review
> that.  What are the contents of these files?  What are the units of
> those contents, etc?
There is a short description before the methods bmp085_get_temperature() and 
bmp085_get_pressure(), but anyway.

Here is a Description of the current sysfs user interface:

The BMP085 digital pressure sensor can measure ambient air pressure and 
temperature. Both values can be obtained from sysfs files. The pressure is 
measured by reading from pressure0_input. Valid values range from 30000 to 
110000 pascal with a resolution of 1 pascal (=0.01 millibar).

temp0_input holds the current temperature in degree celsius, multiplied by 10. 
This results in a resolution of a tenth degree celsius. Values range from -400 
to 850.

To increase the accuracy, this chip can calculate the average of 1, 2, 4 or 8 
samples. This behavior is controlled through the oversampling sysfs file. Two 
to the power of the value written to that file specifies how many samples will 
be used. Valid values: 0..3.


> Are there any similar drivers in the tree (I don't think so) and if so
> does this new driver offer the same interface?
I did not find one.

> Bear in mind that if new drivers for similar devices _do_ come along
> then we'd prefer that those drivers implement the same interface as
> this one.  So is this driver's interface well-designed from that point
> of view?
The pressure0_input and temp0_input should follow the naming convention of 
hwmon devices. I think that would be ok for other sensors too. The 
oversampling is special to this device and others may not support this.

A more general problem is the obtainable resolution. I work on a humidity 
sensor driver for the SHT21. It measures temperatures with a resolution of 
0.01 celsius, ten times higher than the bmp085.
Maybe we need an additional sysfs file which contains the current measurement 
resolution.

I think it would be nice to have a general sensor api which for example 
specifies the sensor type, the units used for this type and the resolution of 
each result.
Any thoughts on this?

> Also, we're supposed to docuemnt these things formally in
> Documentation/ABI/.
I will send a patch for this one too.

> 
> > ...
> > 
> > + * The chip will use 2^oversampling samples for interlan averaging.
> 
> I assumed that was supposed to read "internal".
True.

Best Regards,
  Christoph
