Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0E2CqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 22:46:18 -0400
Received: from bosmailout12.eigbox.net ([66.96.186.12]:42088 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0E2CqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 22:46:15 -0400
X-Greylist: delayed 2006 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 22:46:15 EDT
X-EN-OrigOutIP: 10.20.18.13
X-EN-IMPSID: PECm1e0060GvDVm01ECmZh
Message-ID: <4C007814.3000207@jaysonking.com>
Date: Fri, 28 May 2010 21:12:36 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: tytso@mit.edu
CC: "Jayson R. King" <dev@jaysonking.com>, Stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: Re: [PATCH 2.6.27.y 2/3] ext4: Fix file fragmentation during large
 file write.
References: <4C001888.8020006@jaysonking.com> <4C001901.1070207@jaysonking.com> <20100529010657.GM26177@thunk.org>
In-Reply-To: <20100529010657.GM26177@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 08:06 PM, tytso@mit.edu wrote:
> On Fri, May 28, 2010 at 02:26:57PM -0500, Jayson R. King wrote:
>> From: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>> Date: Thu Oct 16 10:10:36 2008 -0400
>> Subject: ext4: Fix file fragmentation during large file write.
>>
>> commit 22208dedbd7626e5fc4339c417f8d24cc21f79d7 upstream.
>>
>> The range_cyclic writeback mode uses the address_space writeback_index
>> as the start index for writeback.  With delayed allocation we were
>> updating writeback_index wrongly resulting in highly fragmented file.
>> This patch reduces the number of extents reduced from 4000 to 27 for a
>> 3GB file.
>
> This isn't a critical bug fix either.  I don't really care a whole
> lot, since I don't plan to support ext4 with all of these patches but
> if you haven't been doing a full set of testing with these patches,
> I'd be very concerned about whether ext4 would be stable after
> applying this patch series.
>
> What sort of testing _have_ you done?

I've ran dbench for hours on an ext4 volume followed by fsck on the 
volume. Without the patches (particularly, just the last patch, "ext4: 
Implement range_cyclic..."), a typical, sustained moderate to high ext4 
fs load on .27 would often lead to a deadlock. A good demonstration is 
to run "dbench 500" which will usually cause a deadlock in a couple of 
minutes.

I wasn't aware of a way to apply the deadlock fix in "ext4: Implement 
range_cyclic..." without also introducing this patch, since some of the 
blocks it touches are created by this patch.

Thanks for looking.

Rgds,

Jayson
