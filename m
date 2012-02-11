Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2BKIj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 03:39:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61449 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2BKIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 03:39:26 -0500
Message-ID: <4F362938.5090705@redhat.com>
Date: Sat, 11 Feb 2012 09:39:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "Nelson, Doug" <doug.nelson@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com> <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com> <4F3552A4.70902@intel.com> <4F3572C1.1060703@redhat.com> <4F35746A.1090109@intel.com> <4F3584AF.6030601@redhat.com> <4F35AC75.5090703@intel.com>
In-Reply-To: <4F35AC75.5090703@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 12:47 AM, Nelson, Doug wrote:
>
> Here's what I had in 20-local.rules
>
> KERNEL=="sd*", BUS=="scsi", PROGRAM="scsi_id --whitelisted -d
> $tempnode", ENV{ID_BUS}="scsi"
>
> BUS=="scsi", RESULT=="3500151795924153d", NAME="disk-r1e1-d1s%n",
> GROUP:="dba", OWNER:="oracle"
> BUS=="scsi", RESULT=="35001517959269241", NAME="disk-r1e1-d2s%n",
> GROUP:="dba", OWNER:="oracle"
> BUS=="scsi", RESULT=="3500151795926930d", NAME="disk-r1e1-d3s%n",
> GROUP:="dba", OWNER:="oracle"
>

Thanks.  I think we could fix scsi_id to strip a partition number and 
print itself a warning if passed a partition number.

That said, the above rules alone would have failed with latest udev due 
to the use of BUS= (removed in udev 174).

Paolo
