Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2ECH2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:28:07 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:48341 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2ECH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:28:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FA2337B.70609@cam.ac.uk>
Date: Thu, 03 May 2012 08:27:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] IIO: industrialio-core: Use simple_open
References: <1336009851.3590.4.camel@phoenix> <544AC56F16B56944AEC3BD4E3D5917714E79717075@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917714E79717075@LIMKCMBX1.ad.analog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/2012 7:49 AM, Hennerich, Michael wrote:
> Axel Lin wrote on 2012-05-03:
>> Use simple_open to replace iio_debugfs_open.
>>
>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> Acked-by: Michael Hennerich<michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
>> ---
>>   drivers/iio/industrialio-core.c |   10 +---------
>>   1 files changed, 1 insertions(+), 9 deletions(-)
>> diff --git a/drivers/iio/industrialio-core.c
>> b/drivers/iio/industrialio-core.c index 72e33b8..52aa44a 100644 ---
>> a/drivers/iio/industrialio-core.c +++ b/drivers/iio/industrialio-core.c
>> @@ -152,14 +152,6 @@ static void __exit iio_exit(void)
>>   }
>>
>>   #if defined(CONFIG_DEBUG_FS)
>> -static int iio_debugfs_open(struct inode *inode, struct file *file) -{
>> -     if (inode->i_private) -         file->private_data = inode->i_private; -
>> -     return 0; -} -
>>   static ssize_t iio_debugfs_read_reg(struct file *file, char __user
>>   *userbuf,                          size_t count, loff_t *ppos) {
>> @@ -218,7 +210,7 @@ static ssize_t iio_debugfs_write_reg(struct file
>> *file,
>>   }
>>
>>   static const struct file_operations iio_debugfs_reg_fops = {
>> -     .open = iio_debugfs_open,
>> +     .open = simple_open,
>>        .read = iio_debugfs_read_reg,
>>        .write = iio_debugfs_write_reg,
>>   };
> Greetings,
> Michael
>
> --
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
> Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif
>
>

