Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1DGJ5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:57:00 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:58375 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1DGJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:56:58 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9D8ACA.5050309@cam.ac.uk>
Date: Thu, 07 Apr 2011 10:58:34 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: nijs.michael@gmail.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: iio: accel : sca3000_ring: Fixing code styling
 issues
References: <1302117274-9986-1-git-send-email-nijs.michael@gmail.com> <BANLkTin=N2gOcvbgngwZcLEGVK2qoyeLLw@mail.gmail.com>
In-Reply-To: <BANLkTin=N2gOcvbgngwZcLEGVK2qoyeLLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/11 20:24, Belisko Marek wrote:
> On Wed, Apr 6, 2011 at 9:14 PM,  <nijs.michael@gmail.com> wrote:
>> From: Michael Nijs <nijs.michael@gmail.com>
>>
>> Fixed code styling issue.
>>
>> Signed-off-by: Michael Nijs <nijs.michael@gmail.com>
>> ---
>>  drivers/staging/iio/accel/sca3000_ring.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
>> index fd1c844..c872fdd 100644
>> --- a/drivers/staging/iio/accel/sca3000_ring.c
>> +++ b/drivers/staging/iio/accel/sca3000_ring.c
>> @@ -91,7 +91,7 @@ static int sca3000_rip_hw_rb(struct iio_ring_buffer *r,
>>
>>        /* Convert byte order and shift to default resolution */
>>        if (st->bpse == 11) {
>> -               samples = (s16 *)(*data+1);
>> +               samples = (s16*)(*data+1);
> Strange. My output(latest 2.6.39-rc2):
> ./scripts/checkpatch.pl -f drivers/staging/iio/accel/sca3000_ring.c
> ERROR: "(foo*)" should be "(foo *)"
> #94: FILE: staging/iio/accel/sca3000_ring.c:94:
> +		samples = (s16*)(*data+1);
> 
> So for me it seems it was correct and you post patch with change where
> checkpatch will bark. Or am I missing something?
>>                for (i = 0; i < (num_read/2); i++) {
>>                        samples[i] = be16_to_cpup(
>>                                        (__be16 *)&(samples[i]));
There are some much nastier issues with that section of code. If nothing else
I dread to think what be16_to_cpup does with unaligned pointers.  There's a
rewrite of this code in my local tree anyway so either way the issue will probably
go away shortly!

Thanks anyway.

Jonathan
