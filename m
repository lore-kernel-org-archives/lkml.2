Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab2HWSUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:20:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46518 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2HWSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:20:14 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20120823180213.GA31462@google.com>
References: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
	<20120709182018.18165.98339.stgit@bhelgaas.mtv.corp.google.com>
	<CAOesGMgUGUG9Z=x6ssumVkAxN6fHoeyAJ3-P8CoaNTGas7-vmg@mail.gmail.com>
	<20120823180213.GA31462@google.com>
Date: Thu, 23 Aug 2012 11:20:12 -0700
Message-ID: <CAOesGMjU9trQ3RFFfnQp6TOKWJr1ceeEcKx8xW2phW7EHn+bCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: leave MEM and IO decoding disabled during 64-bit
 BAR sizing, too
From: Olof Johansson <olof@lixom.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 23, 2012 at 11:02 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Aug 23, 2012 at 12:28:23AM -0700, Olof Johansson wrote:
>> Hi,
>>
>> On Mon, Jul 9, 2012 at 11:20 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > After 253d2e5498, we disable MEM and IO decoding for most devices while we
>> > size 32-bit BARs.  However, we restore the original COMMAND register before
>> > we size the upper 32 bits of 64-bit BARs, so we can still cause a conflict.
>> >
>> > This patch waits to restore the original COMMAND register until we're
>> > completely finished sizing the BAR.
>> >
>> > Reference: https://lkml.org/lkml/2007/8/25/154
>> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> This patch causes boot lockup on PA Semi hardware, since it disables
>> the bar on the UART that is used for console, and it has printks
>> between the old and the new re-enable location. If I boot with 'debug'
>> level for printk, I hit this. If I boot with just regular console
>> args, I don't.
>>
>> I'm guessing any other platform that uses MMIO-based UART on PCI for
>> console will have similar issues. I can verify on Chrome OS x86
>> hardware tomorrow if legacy powerpc isn't important enough to care
>> about. :-)
>>
>> I have no proposal for a fix for this. Can you please consider
>> reverting for 3.6 unless someone has a better idea?
>
> Thanks a lot for finding and debugging this!
>
> Can you try the patch below?
>
>
> commit cfc29ece86d648e63fb46de81b2bf8e3e107672c
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Thu Aug 23 10:53:08 2012 -0600
>
>     PCI: Don't print anything while decoding is disabled
>
>     If we try to print to the console device while its decoding is disabled,
>     the system will hang.
>
>     Reported-by: Olof Johansson <olof@lixom.net>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Ah yes, of course. Teaches me to try to do anything productive late at
night. Tested fine here.

Acked-by: Olof Johansson <olof@lixom.net>


Thanks!

-Olof
