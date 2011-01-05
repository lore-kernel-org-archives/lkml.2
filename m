Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1AEFmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:42:20 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46824 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1AEFmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fecrPoMo9lse15IlTq3zTpZhwxbfQyn+zq1+t5o7cqOEspWnhCSM4nuMayrXBlLNsG
         nVDOOh508ToUeHPihfWlUtxMx/vpS1S/1/CsSI5wN2gKjQgsik40ERzrZJ0WdC4u9VHA
         gMdHMEfKj5JJmWgE0L8uultj0IylnP5KnfnpM=
Date: Wed, 5 Jan 2011 13:42:07 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jeff Garzik <jeff@garzik.org>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
Message-ID: <20110105054207.GC6256@cr0.nay.redhat.com>
References: <4D22CF9F.1070005@oracle.com>
 <1294150132.4726.0.camel@mulgrave.site>
 <4D235CAC.5070309@garzik.org>
 <4D23E315.9060900@oracle.com>
 <20110105044733.GA6256@cr0.nay.redhat.com>
 <4D24017A.3060202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D24017A.3060202@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 01:28:26PM +0800, DuanZhenzhong wrote:
>Américo Wang 写道:
>>On Wed, Jan 05, 2011 at 11:18:45AM +0800, DuanZhenzhong wrote:
>>>Jeff Garzik 写道:
>>>>On 01/04/2011 09:08 AM, James Bottomley wrote:
>>>>>On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>>>>>Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>>>>
>>>>>>---
>>>>>Description?  Since libsas has no firmware, surely some explanation is
>>>>>required.
>>>>Indeed.  Looks bogus at first glance?
>>>>
>>>>
>>>I was finding all requested but not exported firmware in scsi driver
>>>for generating dump initrd use.
>>>In sas_scsi_host.c, request_firmware is called with "sas_addr",
>>>sas_addr neither builtin nor exported. Don't sas_addr a firmware?
>>>Please correct me. thanks
>>>
>>
>>But once you export it, it needs to be found in fireware/ directory...
>Not exactly, firmware/ dir only have a subset of all needed firmware.
>Also one can load firmware manually from anywhere
>

Then it should not be exported, otherwise user-space will get confused.
We have a script to parse modinfo output to get the firmwares of a module.
