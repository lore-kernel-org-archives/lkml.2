Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2BQN2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:28:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55173 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2BQN2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:28:33 -0500
MIME-Version: 1.0
In-Reply-To: <20120217131247.GN27825@n2100.arm.linux.org.uk>
References: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
	<20120217131247.GN27825@n2100.arm.linux.org.uk>
Date: Fri, 17 Feb 2012 18:58:33 +0530
Message-ID: <CAB4K4y7RSwTLZq_N4jY3vDGYCmde-CTvVH5sBdzYfaiPsJMmGA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dma-mapping: fix leak in consistent_init
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you for kind review, but how can I resent the patch using same mail chain

git send-email --smtp-encryption=tls --smtp-server=smtp.gmail.com
--smtp-user=ajeet.yadav.77@gmail.com --smtp-server-port=587 --from
"Ajeet Yadav <ajeet.yadav.77@gmail.com>" --to "Russell King
<linux@arm.linux.org.uk>" --to "Jon Medhurst <tixy@yxit.co.uk>" --to
"Nicolas Pitre <nicolas.pitre@linaro.org>" --to "Catalin Marinas
<catalin.marinas@arm.com>" --to "Sumit Bhattacharya
<sumitb@nvidia.com>" --to "linux-arm-kernel@lists.infradead.org" --to
"linux-kernel@vger.kernel.org"
0002-ARM-dma-mapping-fix-leak-in-consistent_init.patch

On Fri, Feb 17, 2012 at 6:42 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Feb 17, 2012 at 06:39:55PM +0530, Ajeet Yadav wrote:
>> Although the error in this case is unlikely, but logically
>> if error occurs then we leak memory.
>>
>> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> ---
>>  arch/arm/mm/dma-mapping.c |   24 ++++++++++++------------
>>  1 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>> index 04bfa76..b8cf062 100644
>> --- a/arch/arm/mm/dma-mapping.c
>> +++ b/arch/arm/mm/dma-mapping.c
>> @@ -161,7 +161,6 @@ static struct arm_vmregion_head consistent_head = {
>>   */
>>  static int __init consistent_init(void)
>>  {
>> -     int ret = 0;
>>       pgd_t *pgd;
>>       pud_t *pud;
>>       pmd_t *pmd;
>> @@ -171,7 +170,7 @@ static int __init consistent_init(void)
>>       unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
>>
>>       consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
>> -     if (!consistent_pte) {
>> +     if (unlikely(!consistent_pte)) {
>
> Please get rid of these unlikelys.  This really isn't a performance
> critical path.
