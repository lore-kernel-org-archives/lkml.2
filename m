Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2JWPrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:47:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38688 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab2JWPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <20121023154226.GB16140@aftab.osrc.amd.com>
References: <1350921364-26366-1-git-send-email-kirjanov@gmail.com>
	<20121023154226.GB16140@aftab.osrc.amd.com>
Date: Tue, 23 Oct 2012 19:47:41 +0400
Message-ID: <CAHj3AVkZnFh1K7fpL8tGzHDXkMjiXBXiU4JE6XbpfmEzOHpZPw@mail.gmail.com>
Subject: Re: [PATCH] check the kzalloc return value
From: Denis Kirjanov <kirjanov@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll resubmit a new patch.

Thanks!

On 10/23/12, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, Oct 22, 2012 at 07:56:04PM +0400, Denis Kirjanov wrote:
>>
>
> Needs a commit message.
>
>> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
>> ---
>>  drivers/edac/edac_mc_sysfs.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
>> index ed0bc07..55ce016 100644
>> --- a/drivers/edac/edac_mc_sysfs.c
>> +++ b/drivers/edac/edac_mc_sysfs.c
>> @@ -1128,7 +1128,8 @@ int __init edac_mc_sysfs_init(void)
>>  	}
>>
>>  	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
>> -
>> +	if (!mci_pdev)
>> +		return -ENOMEM;
>
> This either needs to do
>
> 	edac_put_sysfs_subsys();
>
> on the error-out path.
>
>>  	mci_pdev->bus = edac_subsys;
>>  	mci_pdev->type = &mc_attr_type;
>>  	device_initialize(mci_pdev);
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
>


-- 
Regards,
Denis
