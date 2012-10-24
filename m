Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab2JXJNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:13:48 -0400
Received: from mx0.aculab.com ([213.249.233.131]:34235 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753236Ab2JXJNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:13:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH v2 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
Date: Wed, 24 Oct 2012 10:06:36 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7060@saturn3.aculab.com>
In-Reply-To: <CACVXFVN+=XH_f5BmRkXeagTNowz0o0-Pd7GcxCneO0FSq8xqEw@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [RFC PATCH v2 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
thread-index: Ac2xMehlIZK+/a3NSEiPhIv77D7QvwAk8FDQ
References: <CACVXFVMmszZWHaeNS6LSG4nHR4wWBLwM_BvynRwUW8X=nO+JWA@mail.gmail.com><Pine.LNX.4.44L0.1210231022230.1635-100000@iolanthe.rowland.org> <CACVXFVN+=XH_f5BmRkXeagTNowz0o0-Pd7GcxCneO0FSq8xqEw@mail.gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Ming Lei" <ming.lei@canonical.com>,
        "Alan Stern" <stern@rowland.harvard.edu>
Cc: <linux-kernel@vger.kernel.org>, "Oliver Neukum" <oneukum@suse.de>,
        "Minchan Kim" <minchan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Jens Axboe" <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        "Andrew Morton" <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks the problem is worse than above, not only bitfields are affected, the
> adjacent fields might be involved too, see:
> 
>            http://lwn.net/Articles/478657/

Not mentioned in there is that even with x86/amd64 given
a struct with the following adjacent fields:
	char a;
	char b;
	char c;
then foo->b |= 0x80; might do a 32bit RMW cycle.
This will (well might - but probably does) happen
if compiled to a 'BTS' instruction.
The x86 instruction set docs are actually unclear
as to whether the 32bit cycle might even be misaligned!
amd64 might do a 64bit cycle (not checked the docs).

	David



