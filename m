Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2JBWvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:51:00 -0400
Received: from server505f.appriver.com ([98.129.35.10]:3837 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198Ab2JBWu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:50:58 -0400
X-Note-AR-ScanTimeLocal: 10/2/2012 5:50:57 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G321 G322 G323 G324 G328 G329 G340 G436 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Oct 2012 17:50:55 -0500
Subject: Re: [PATCH 4/7] aoe: make dynamic block minor numbers the default
Thread-Topic: [PATCH 4/7] aoe: make dynamic block minor numbers the default
Thread-Index: Ac2g8GH9xtcT0lWJSI2HaA2REId6Fg==
Message-ID: <4FD96533-B1C0-4795-993C-AE188AD894D9@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
 <4b1456739285d5a7a153ba74a51f3e3bfd5c4a53.1349104674.git.ecashin@coraid.com>
 <20121002141734.56ee52b3.akpm@linux-foundation.org>
In-Reply-To: <20121002141734.56ee52b3.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2, 2012, at 5:17 PM, Andrew Morton wrote:
...
>> The static arrangement is still available with aoe_dyndevs=0, and
>> the aoe-stat tool from the userland aoetools package, the user
>> space counterpart to the aoe driver, recognizes the case where
>> there is a mismatch between the minor number in sysfs and the
>> minor number in a special device file.
> 
> Oh.  There we are.
> 
> Again, what are the back-(in)compatibility issues which users might
> encounter with this?

I think the people who care about aoe_dyndevs=0 are the people creating
an initramfs without udev and with AoE targets that have low shelf and
slot numbers for addresses.

They might want a tiny bzImage that can boot off AoE storage using
device nodes prepared in advance with mknod.  The old static mapping
is a nice fit for that use case.

There could be others with a reason not to use udev, but none of those
others have ever communicated with me, if they exist.

It's probably confusing the way I did the commits, making static the
default before explicitly changing it to dynamic, but usually the people
who actually care about this are so technical that I expect them to read
the git logs, and I wanted to leave a paper trail there for anyone reading
later.

-- 
  Ed Cashin
  ecashin@coraid.com


