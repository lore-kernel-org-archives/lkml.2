Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0K2Tfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:35:41 -0500
Received: from gateway.promise.com ([67.111.72.2]:28569 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368Ab0K2Tfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:35:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Subject: RE: data corruption with stex (Promise HW-Raid) driver and device-mapper
Date: Mon, 29 Nov 2010 11:35:37 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F04A4A6A1@nonamew.ptu.promise.com>
In-Reply-To: <4CEE32F0.4030302@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: data corruption with stex (Promise HW-Raid) driver and device-mapper
Thread-Index: AcuMhzd5TRF5qFDdR0CtRya8FUEXkQDa/Hyg
From: "Ed Lin - PTU" <ed.lin@promise.com>
To: "Milan Broz" <mbroz@redhat.com>
Cc: "Dan Carpenter" <error27@gmail.com>, "Markus Schulz" <msc@antzsystem.de>,
        <linux-kernel@vger.kernel.org>,
        "device-mapper development" <dm-devel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Milan Broz [mailto:mbroz@redhat.com] 
>Sent: 2010年11月25日 1:57
>To: Ed Lin - PTU
>Cc: Dan Carpenter; Markus Schulz; 
>linux-kernel@vger.kernel.org; device-mapper development
>Subject: Re: data corruption with stex (Promise HW-Raid) 
>driver and device-mapper
>
>
>On 11/16/2010 02:35 AM, Ed Lin - PTU wrote:
>> The stex driver sets sg_tablesize as 32 (for st_yel it's 38) 
>in the probe
>> entry. It seems that this value was overridden by the system if using
>> dm/lvm, for unknown reason. The driver received requests with more
>> sg items than registered. Sg item number could be as high as 64. This
>> is completely unexpected. The firmware could not handle such
>> requests, and error occurred.
>
>Device-mapper respects hw restrictions, so it must be bug somewhere.
>
>Please cc dm-devel if you think that problem is there.
>

Hello,

This problem is fixed. Martin Petersen proposed a thorough cleaning at
http://marc.info/?l=dm-devel&m=129070330506836&w=2 .
My original patch is at
http://marc.info/?l=dm-devel&m=129067980708110&w=2 ,
which is a simplified minimum version.

Thanks,
Ed Lin
