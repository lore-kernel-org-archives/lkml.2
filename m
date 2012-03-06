Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab2CFOOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:14:42 -0500
Received: from mga10.intel.com ([192.55.52.92]:53008 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758612Ab2CFOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:14:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.60.27.6 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <4F55D6F6.2040906@debian.org>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
	<20120127144737.GA27750@andromeda.dapyr.net>
	<20120219223125.GA820@burratino>
	<20120220181618.GD17566@burratino>
	<4F4891B8.9050008@goirand.fr>
	<20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	<20120302175719.GA1468@wavehammer.waldi.eu.org>
	<CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	<4F54DB1F.3080000@debian.org>
	<CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
	<4F55D6F6.2040906@debian.org>
Date: Tue, 6 Mar 2012 06:14:29 -0800
Message-ID: <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Thomas Goirand <zigo@debian.org>
Cc: xen-devel@lists.xensource.com, Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 1:20 AM, Thomas Goirand <zigo@debian.org> wrote:
> On 03/05/2012 11:38 PM, Dan Williams wrote:
>> On Mon, Mar 5, 2012 at 7:26 AM, Thomas Goirand <zigo@debian.org> wrote:
>>> I will do my best to provide it ASAP. Should I compile with BUG_ON so
>>> you see it crashing, as per the original code, or just with WARN_ON, so
>>> you also see further things in dmesg?
>>
>> Yes, replacing with a WARN_ON might allow it to skid after the crash
>> and give a bit more information.
>>
>> Thank you for grabbing this info.
>>
>> --
>> Dan
>
> Hi Dan,
>
> Please find attached the log that you asked me, with WARN_ON instead of
> BUG_ON, and with the 2 #define DEBUG in dma.c and dma_v2.c.
>

[    9.276817] ioatdma 0000:00:16.4: desc[0]:
(0x300cc7000->0x300cc7040) cookie: 0 flags: 0x2 ctl: 0x29 (op: 0
int_en: 1 compl: 1)
...
[    9.276832] ioatdma 0000:00:16.4: ioat_get_current_completion:
phys_complete: 0xcc7000

Thanks, this clearly shows that our descriptors are above 4GB and that
the driver truncates the completion word.

Is this new behavior for xen?

Before you had mentioned that non-xen 32-bit builds don't fail.  Can
you send me the .config from those two cases (offlist if they are too
large)?  I'm looking for what config option enables this so I can
quote it in the patch to increase the size of phys_complete.
Certainly this changes my assumptions of what address ranges
GFP_KERNEL memory will be located.

--
Dan
