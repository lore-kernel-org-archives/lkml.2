Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0JHQDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0JHQDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:03:23 -0400
Message-ID: <4CAF40A0.5020506@redhat.com>
Date: Fri, 08 Oct 2010 18:02:40 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
References: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com> <1286490947.23573.3.camel@mulgrave.site> <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 03:47 PM, Yang, Bo wrote:
> James,
>
> Thanks for getting the online controller reset in.  I downloaded patch 2/5 from  http://marc.info/?l=linux-scsi&m=128521127203199&w=2 and I can apply it without errors.
>
> Can you try it again?  otherwise I need to re-attach it.
>   
I've tried it (http://marc.info/?l=linux-scsi&m=128521127203199&w=2) and it is broken.
If you look at the end of the patche there should be 3 lines of the original code after 
the last + sign.

tomash

Broken:
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in

Works for me:
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 <- this line is missing in your patch
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in



> Thanks,
>
> Bo Yang    
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de] 
> Sent: Thursday, October 07, 2010 6:36 PM
> To: bo yang
> Cc: Yang, Bo; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
>
> On Wed, 2010-09-22 at 22:50 -0400, bo yang wrote:
>   
>> Driver added the Device update flag to tell LSI application driver
>> will do the device Update.  LSI MegaRAID SAS application will check
>> this flag to decide if it is need to update the Device or not.
>>     
> Well, the good news is I've got the Online Controller reset update. The
> bad news is that this patch now fails to apply: looks like an attachment
> problem again:
>
> Applying: megaraid_sas: support devices update flag
> fatal: corrupt patch at line 70
> Patch failed at 0001 megaraid_sas: support devices update flag
>
> James
>
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��!tml=

