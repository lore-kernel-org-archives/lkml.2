Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0DNHzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:55:14 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:59255 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0DNHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:55:12 -0400
Message-ID: <4BC57478.3080902@lumino.de>
Date: Wed, 14 Apr 2010 09:53:28 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: monstr@monstr.eu
CC: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stefan Asserhall <stefan.asserhall@xilinx.com>,
       Goran Bilski <goran@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
       Grant Likely <grant.likely@secretlab.ca>, sam@ravnborg.org,
       stephenn@xilinx.com, Karen Whelan <karen.whelan@petalogix.com>,
       Wendy Liang <wendy.liang@petalogix.com>
Subject: Re: Microblaze - The fist year
References: <4BC461AD.6090504@monstr.eu> <4BC46DC6.5050309@lumino.de> <4BC4713F.6030702@monstr.eu>
In-Reply-To: <4BC4713F.6030702@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 03:27 PM, Michal Simek wrote:
>
> yes, futex is there. You can check it in
> arch/microblaze/include/asm/futex.h
Great ! I'll check how this is done.
>
>> Does Microblaze MMU Linux support SMP ?
>
> It is possible to connect several MicroBlazes but the problem is
> missing cache coherency modul. I hope that Xilinx will release any
> version which will support it.
> We haven't done any significant work to support it but it is expected
> solution which will happen.

Besides cache coherency, another problem might be doing FUTEX. here (I
suppose) SMP safe atomic user space operations are necessary. many
simple RISK (load/store-) CPUs don't provide these (new ARMs provide
"load-locked / store-conditional" on that behalf as an extension to the
load/store paradigm. I suppose these can be done in an SMP-safe way,
supposedly using the hardware that provides cache coherency).

-Michael
