Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2GIUJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:09:34 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51196 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2GIUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:09:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
	<1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
	<20120709200604.GA2536@kroah.com>
Date: Mon, 09 Jul 2012 13:09:23 -0700
In-Reply-To: <20120709200604.GA2536@kroah.com> (Greg Kroah-Hartman's message
	of "Mon, 9 Jul 2012 13:06:04 -0700")
Message-ID: <877guc4ryk.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+PVEc4VBmHFbCWlq5eXE3sKH2uj4lJu8E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] staging/slicoss: disable pci device at remove
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Jul 09, 2012 at 11:04:19PM +0530, Devendra Naga wrote:
>> at probe we enabled the device, and we should disable it at remove.
>> 
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> ---
>>  drivers/staging/slicoss/slicoss.c |    1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
>> index a511a2b..5bd3825 100644
>> --- a/drivers/staging/slicoss/slicoss.c
>> +++ b/drivers/staging/slicoss/slicoss.c
>> @@ -3234,6 +3234,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
>>  	}
>>  	free_netdev(dev);
>>  	pci_release_regions(pcidev);
>> +	pci_disable_device(pcidev);
>
> No, you really shouldn't do this, see the many times this has come up on
> the linux-kernel mailing list for why.

I haven't see this?  Why don't you want to disable a device at remove
time?  Because we put the disable in the generic pci layer?

Eric
