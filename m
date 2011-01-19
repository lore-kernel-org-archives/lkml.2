Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1ASPxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:53:43 -0500
Received: from daytona.panasas.com ([67.152.220.89]:48180 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1ASPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:53:42 -0500
Message-ID: <4D370902.2020501@panasas.com>
Date: Wed, 19 Jan 2011 17:53:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Dillow <dillowda@ornl.gov>
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3]  fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES
 in a bio
References: <1294977946.21790.20.camel@obelisk.thedillows.org>	 <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>	 <1295023584.24487.16.camel@lap75545.ornl.gov>	 <x49y66jmljv.fsf@segfault.boston.devel.redhat.com>	 <1295319627.3051.89.camel@obelisk.thedillows.org>	 <20110118165359.09023fe9.akpm@linux-foundation.org> <1295404470.5233.31.camel@obelisk.thedillows.org>
In-Reply-To: <1295404470.5233.31.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2011 15:53:41.0661 (UTC) FILETIME=[0B68CCD0:01CBB7F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 04:34 AM, David Dillow wrote:
> On Tue, 2011-01-18 at 16:53 -0800, Andrew Morton wrote:
>>
>> Well.  -stable only needs the patch if the driver which triggers the
>> problem is also there.  But we don't know what driver that is, yet???
> 
> Good point.
> 
> Any driver that supports a sg_tablesize of more than 256 has the
> potential for problems. A quick search of the tree indicates that the
> following set their initial sg_tablesize to SCSI_MAX_SG_CHAIN_SEGMENTS
> (2048), though they may be saved by a separate bug I found -- and sent a
> patch to the list -- that incorrectly causes that define to take the
> value 128. 
> 
> ./drivers/usb/storage/scsiglue.c
> ./drivers/scsi/arm/powertec.c
> ./drivers/scsi/arm/eesox.c
> ./drivers/scsi/arm/cumana_2.c
> ./drivers/ata/pata_icside.c
> 
<snip>

iscsi has it on 2048 since ever

Boaz
