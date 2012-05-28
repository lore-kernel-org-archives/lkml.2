Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2E1R5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 13:57:22 -0400
Received: from mga12.intel.com ([143.182.124.36]:24880 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753049Ab2E1R5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 13:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1205281835400.32511@debianer>
References: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org>
	<201205252127.21436.rjw@sisk.pl>
	<alpine.DEB.2.02.1205281835400.32511@debianer>
Date: Mon, 28 May 2012 10:56:58 -0700
Message-ID: <CABE8wwsormFTiyE8Qepq_DBZ1rcA5P1+L9xLfgA7S8VY7_t0+Q@mail.gmail.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not recognized
From: Dan Williams <dan.j.williams@intel.com>
To: Eldad Zack <eldadzack@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <jejbbe@hansenpartnership.com>,
        David Miller <davem@davemloft.net>, mroos@linux.ee,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 9:46 AM, Eldad Zack <eldadzack@gmail.com> wrote:
>
> On Fri, 25 May 2012, Rafael J. Wysocki wrote:
>> On Friday, May 25, 2012, Alan Stern wrote:
>> > On Fri, 25 May 2012, James Bottomley wrote:
>> >
>> > Whether or not the boot kernel can have modular drivers isn't clear to me;
>>
>> It can, but then the code in question is irrelevant and the resume has to
>> be triggered in a different way.  For example, by writing to
>> /sys/power/resume from the initrd boot scripts.
>>
>> > I don't know when the check for a valid image in the swap area is carried
>> > out in relation to starting up the initramfs task.
>>
>> This particular one is carried out before the initrd is loaded.
>
> I just got hit by this one too, but on x86 qemu. There's no initrd, and all
> the modules are built in.
>
> With commit a7a20d103994fd760766e6c9d494daa569cbfe06 the kernel doesn't
> get to the point where it reads the partition table.
>
> If it's of any help, I can provide more details.

Yes, please send the qemu config details.

The proposed fix for 3.5 is here:
http://marc.info/?l=linux-scsi&m=133796775807498&w=2

--
Dan
