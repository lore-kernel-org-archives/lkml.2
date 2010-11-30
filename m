Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0K3P5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:57:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0K3P5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:57:45 -0500
Message-ID: <4CF51EF2.1010606@redhat.com>
Date: Tue, 30 Nov 2010 16:57:38 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>,
        "Prabhakaran, Rajesh" <Rajesh.Prabhakaran@lsi.com>
Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads from
 FW
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96223@cosmail02.lsi.com> <1290189181.23556.77.camel@mulgrave.site> <4B6A08C587958942AA3002690DD4F8C30106B1DEB9@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106B1DEB9@cosmail02.lsi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 04:22 PM, Yang, Bo wrote:
> James,
>
> Our megaraid sas driver only implemented the part of the XOR calculation and copy capability(moving data between 2 buffers) for the RAID5 cmds which FW asks driver to do.  When fw received very heavy I/Os and there are high pending cmds in FW, fw will ask the help from driver to finish some cmds and reduce the fw heavy load.  Driver will only do part of the RAID5 (not take the jobs) from FW.  Driver is not duplicating Parity calculation done on dm/md.
>   
Do I understand it right - it means that the computation is done sometimes in the firmware and
sometimes in the driver depending on the load? I think it is not good having two complicated
computations on two different places. Wouldn't it better to compute it always in the driver?
Could we get a module option for choosing this computation - a)automatic, b)only in fw
c)only in driver?

Tomas


> Thanks,
>
> Bo Yang  
>
>
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Friday, November 19, 2010 12:53 PM
> To: Yang, Bo
> Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Tomas Henzl
> Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads from FW
>
> On Fri, 2010-11-19 at 10:43 -0700, Yang, Bo wrote:
>   
>> Driver added the new feature to take some of the workloads from FW to increase
>> performance of the iMR controller.  FW assigns the read cmds back to driver
>> which will increase the performance for megaraid sas iMR controller.
>>     
> Just on a process note: you don't have to cc me at every known
> address ... I do read linux-scsi ...
>
> My first take on this patch is that you're basically passing data back
> to the kernel for RAID-N parity calculations.  This effectively makes
> your RAID one of those pseudo HW ones.  In which case, why not simply
> abandon the HW raid piece and have it all done by DM/MD, which are well
> optimised for all types of RAID?  The reason for asking is that we're
> trying to reduce the number of in-kernel raid implementations and this
> is going in the wrong direction.
>
> James
>
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��!tml=

