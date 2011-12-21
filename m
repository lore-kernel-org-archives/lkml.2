Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1LUBck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:32:40 -0500
Received: from mga07.intel.com ([143.182.124.22]:26895 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752770Ab1LUBcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B286840@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
	<CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
	<6E21E5352C11B742B20C142EB499E0481B286840@TK5EX14MBXC122.redmond.corp.microsoft.com>
Date: Tue, 20 Dec 2011 17:32:35 -0800
Message-ID: <CABE8wwsat+JGLiKpu_70bxZQAYegdrcsow=9XXBabwgWUgBT4Q@mail.gmail.com>
Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
 out of the staging area
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 4:42 PM, KY Srinivasan <kys@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Behalf Of
>> Dan Williams
>> Sent: Tuesday, December 20, 2011 6:06 PM
>> To: KY Srinivasan
>> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
>> James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
>> scsi@vger.kernel.org
>> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
>> out of the staging area
>>
>> On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.com> wrote:
>> > The storage driver (storvsc_drv.c) handles all block storage devices
>> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
>> > staging tree for a while and this patch moves it out of the staging area.
>> > As per Greg's recommendation, this patch makes no changes to the staging/hv
>> > directory. Once the driver moves out of staging, we will cleanup the
>> > staging/hv directory.
>> >
>> > This patch includes all the patches that I have sent against the staging/hv
>> > tree to address the comments I have gotten to date on this storage driver.
>> > Greg has already applied all these patches to the staging tree.
>> >
>> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>> > ---
>> >  drivers/scsi/Kconfig       |    7 +
>> >  drivers/scsi/Makefile      |    3 +
>> >  drivers/scsi/storvsc_drv.c | 1586
>> ++++++++++++++++++++++++++++++++++++++++++++
>> >  3 files changed, 1596 insertions(+), 0 deletions(-)
>> >  create mode 100644 drivers/scsi/storvsc_drv.c
>>
>> Shouldn't this diffstat be something like the following?
>>
>>  drivers/scsi/Kconfig                       |    7 +
>>  drivers/scsi/Makefile                      |    3 +
>>  drivers/{staging/hv => scsi}/storvsc_drv.c |  310 +++++++++++++++++++---------
>>  3 files changed, 218 insertions(+), 102 deletions(-)
>>  rename drivers/{staging/hv => scsi}/storvsc_drv.c (87%)
>
> As per Greg's suggestion, this patch does not remove the driver from
> the staging tree. Once the driver lands in the correct directory, we will
> remove the driver from the staging directory.

Ah, ok, so the patch can be accepted in parallel with the staging update.

I still think it wouldn't hurt to show what:

git diff --stat --summary -M

...is after the removal of the version in drivers/staging/hv/ to
quickly show that git agrees that the versions are indeed identical,
but no big deal.
