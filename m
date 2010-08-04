Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0HDDXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:23:13 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:47757 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab0HDDXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:23:11 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 5/6] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Topic: [PATCH 5/6] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Index: AcszLcUhHXq5Q0YpSPmrzukUj2qQ+AAP8+aAAAV/g1A=
Date: Wed, 4 Aug 2010 03:23:09 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE59CB@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D36@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803174005.GC1455@suse.de>
In-Reply-To: <20100803174005.GC1455@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>And than Greg KH spoke these words:
>>On Tue, Aug 03, 2010 at 05:31:55PM +0000, Hank Janssen wrote:
> >From: Hank Janssen <hjanssen@microsoft.com>
> >
> >Increased storvsc ringbuffer and max_io_requests. This now more 
> >closely mimics the numbers on Hyper-V.
>
>What do you mean by this?  The max provided by the hypervisor?

Max_IO is set to double from what it was before, Hyper-V allows it and
We have had appliance builder requests to see if it was a problem to increase
The number.

Ringbuffer size for storvsc is now increased because I have seen 
A few buffer problems on extremely busy systems. They where 
Set pretty low before. And since max_io_requests is increased I
Really needed to increase the buffer as well.

>> And will allow more IO requests to take place for the SCSI driver.
>
>Which means what, better throughput?  Or just more outstanding requests and the same speed overall?

It means better throughput of high load systems, else you get buffer
Contention. 

Thanks,

Hank.

