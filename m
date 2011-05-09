Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1EIO4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:56:55 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:51487 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1EIO4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:56:54 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: various vmbus review comments
Thread-Topic: various vmbus review comments
Thread-Index: AQHMCdM/6BBvI53KVEebJyh4jiWUR5R8ywQggACIZQCAAm/aIIAFSqsA//+P6RA=
Date: Mon, 9 May 2011 14:56:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481E95C6@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110509143352.GB29635@infradead.org>
In-Reply-To: <20110509143352.GB29635@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, May 09, 2011 10:34 AM
> To: KY Srinivasan
> Cc: Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: various vmbus review comments
> 
> On Fri, May 06, 2011 at 01:10:38PM +0000, KY Srinivasan wrote:
> > I audited the block and the net drivers. As part of their exit routine,
> > they invoke vmbus_child_driver_unregister() after properly cleaning
> > up all the devices they are managing. Do you still see an issue with
> > regards to module reference counting.
> 
> Which is not the correct thing to do as explained in my last round
> of reviews.  Take a look at the PCI code - the functional driver only
> does a foo_untegister_driver (which maps almost directly to
> driver_unregister), which then causes the device core to unbind the
> devices.  The function driver must never call device_unregister
> directly as the device continues to exist even if no driver is bound to
> it.

I will address this. Greg had a concern about module reference counting
and looking at the current code, it did not appear to be an issue. The
change you are suggesting will not affect the vmbus core which is what I want
to focus on. I will however, fix this issue in the current round of patches I will
send out this week.

Regards,

K. Y


