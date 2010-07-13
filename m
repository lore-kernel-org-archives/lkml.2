Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0GMWIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:08:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64435 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0GMWIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mjRqpO3wXqBKFxxhSH1ve7wufM48ORCtZkog7RSQJEOSY5nCYi/Mh1CZVCeVsedhCs
         I/mT2f202Y8r/bpVMUyd7SYO+doWV+3Y4GU3cloHKz2E+/e0oOegjlZnWPvwNy5R/PRz
         FRX7sxEgKSxo7Qf5fCPgSOt7LvvH9o/E6khuo=
MIME-Version: 1.0
In-Reply-To: <1278594883.3313.33.camel@localhost.localdomain>
References: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
	<1278594883.3313.33.camel@localhost.localdomain>
Date: Wed, 14 Jul 2010 07:08:22 +0900
Message-ID: <AANLkTilMKH5M0d8iyACTDLMwZb1WgyJVrd9e04H2cy95@mail.gmail.com>
Subject: Re: [Linux-ima-user] [RFC][PATCH] ima: add default rule for initramfs 
	files
From: Seiji Munetoh <seiji.munetoh@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 10:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2010-07-06 at 17:08 +0200, Roberto Sassu wrote:
>> This patch modifies the default policy shipped with IMA, in order to avoid measurements
>> of files in the initial ramdisk. Those files can be measured early in the boot process
>> by the bootloader.
>> The patch applies to latest version of the mainline kernel 2.6.35-rc4.
>
> Yes, the initramfs measurements are therefore redundant, as they're
> already included in the initramfs measurement, but perhaps, as the
> number of initramfs is very limited and the individual file measurements
> supplies additional information, it wouldn't hurt to keep the individual
> file measurements as well.  These measurements could potentially help in
> identifying initramfs changes.
>
> Would appreciate other opinions before accepting this change.

The hash value of the initramfs is unstable since it was generated
at the time of kernel installation.
So still I want to check  the individual used file in initramfs.

regards,
--
Seiji



>
> thanks,
>
> Mimi
>
>> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
>> ---
>>  security/integrity/ima/ima_policy.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index aef8c0a..92d8d0e 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -64,6 +64,7 @@ static struct ima_measure_rule_entry default_rules[] = {
>>       {.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
>>       {.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
>>       {.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
>> +     {.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
>>       {.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
>>        .flags = IMA_FUNC | IMA_MASK},
>>       {.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
>
>
>
> ------------------------------------------------------------------------------
> This SF.net email is sponsored by Sprint
> What will you do first with EVO, the first 4G phone?
> Visit sprint.com/first -- http://p.sf.net/sfu/sprint-com-first
> _______________________________________________
> Linux-ima-user mailing list
> Linux-ima-user@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-ima-user
>
