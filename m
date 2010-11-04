Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0KDNPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:15:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0KDNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:15:04 -0400
Message-ID: <4CD2B1CB.6070004@vlnb.net>
Date: Thu, 04 Nov 2010 16:14:51 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC v2 16/21] tcm: Add PSCSI subsystem plugin
References: <1285195867-11728-1-git-send-email-nab@linux-iscsi.org> <4CD01EE2.20705@panasas.com>
In-Reply-To: <4CD01EE2.20705@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:68KkbUrkYlnKKas2kfviPu8A7mscSptAIfZlRUkj7Vw
 bRZYTR/pJdwH+EouKMxydo8sZRJKX9xTV+RqINdNwd8VuOD8q7
 F0Sxq6rDk62KT3y4Is1YgoBGsT1IAfgdADG6o7lVgWwbTJBNoa
 7jb6PGcsAR8rbyKB5dvfsbEUkjfZOU+kY6mYHebqPGMAhlqyFP
 X/vmQAOqA46vV4xT2yvdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh, on 11/02/2010 05:23 PM wrote:

[...]

>> +	 * Some pseudo SCSI HBAs do not fill in sector_size
>> +	 * correctly. (See ide-scsi.c)  So go ahead and setup sane
>> +	 * values.
>> +	 */
>> +	if (!sd->sector_size) {
>> +		switch (sd->type) {
>> +		case TYPE_DISK:
>> +			sd->sector_size = 512;
>> +			break;
>> +		case TYPE_ROM:
>> +			sd->sector_size = 2048;
>> +			break;
>> +		case TYPE_TAPE: /* The Tape may not be in the drive */
>> +			break;
>> +		case TYPE_MEDIUM_CHANGER: /* Control CDBs only */
>> +			break;
>> +		default:
>> +			printk(KERN_ERR "Unable to set sector_size for %d\n",
>> +					sd->type);
>> +			return NULL;
> 
> What about sector-less devices? OSD, Scanners, printers ...

[...]

>> +	/*
>> +	 * For TYPE_TAPE, attempt to determine blocksize with MODE_SENSE.
>> +	 */
>> +	if (sd->type == TYPE_TAPE) {
> 
> Just as a future note:
> One of the things I'm missing from LIO is the notion of SCSI_TYPE or SCSI
> class. So things like this can be done in a plugin manner as per TYPE
> Like in the Kernel we have the ULDs for that.

This is exactly how it is done in SCST.

Also SCST well handles sector-less devices.

Vlad
