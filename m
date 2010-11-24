Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0KXPWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:22:13 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:49230 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab0KXPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:22:10 -0500
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>,
        "Prabhakaran, Rajesh" <Rajesh.Prabhakaran@lsi.com>
Date: Wed, 24 Nov 2010 08:22:21 -0700
Subject: RE: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads
 from FW
Thread-Topic: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads
 from FW
Thread-Index: AcuIEqZLLSCnFw0qQv6jwQQTCLAWhQD1sPnw
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106B1DEB9@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96223@cosmail02.lsi.com>
 <1290189181.23556.77.camel@mulgrave.site>
In-Reply-To: <1290189181.23556.77.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAOFMSNu013125

James,

Our megaraid sas driver only implemented the part of the XOR calculation and copy capability(moving data between 2 buffers) for the RAID5 cmds which FW asks driver to do.  When fw received very heavy I/Os and there are high pending cmds in FW, fw will ask the help from driver to finish some cmds and reduce the fw heavy load.  Driver will only do part of the RAID5 (not take the jobs) from FW.  Driver is not duplicating Parity calculation done on dm/md.

Thanks,

Bo Yang  



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, November 19, 2010 12:53 PM
To: Yang, Bo
Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Tomas Henzl
Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads from FW

On Fri, 2010-11-19 at 10:43 -0700, Yang, Bo wrote:
> Driver added the new feature to take some of the workloads from FW to increase
> performance of the iMR controller.  FW assigns the read cmds back to driver
> which will increase the performance for megaraid sas iMR controller.

Just on a process note: you don't have to cc me at every known
address ... I do read linux-scsi ...

My first take on this patch is that you're basically passing data back
to the kernel for RAID-N parity calculations.  This effectively makes
your RAID one of those pseudo HW ones.  In which case, why not simply
abandon the HW raid piece and have it all done by DM/MD, which are well
optimised for all types of RAID?  The reason for asking is that we're
trying to reduce the number of in-kernel raid implementations and this
is going in the wrong direction.

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
