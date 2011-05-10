Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1EJNA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:00:28 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:19018 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1EJNA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:00:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: various vmbus review comments
Thread-Topic: various vmbus review comments
Thread-Index: AQHMCdM/6BBvI53KVEebJyh4jiWUR5R8ywQggACIZQCAAm/aIIAFSqsA//+P6RCAAWjogIAAB8ow
Date: Tue, 10 May 2011 13:00:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481EEFF1@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110509143352.GB29635@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481E95C6@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110510052425.GA31087@infradead.org>
In-Reply-To: <20110510052425.GA31087@infradead.org>
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
> Sent: Tuesday, May 10, 2011 1:24 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: various vmbus review comments
> 
> On Mon, May 09, 2011 at 02:56:52PM +0000, KY Srinivasan wrote:
> > I will address this. Greg had a concern about module reference counting
> > and looking at the current code, it did not appear to be an issue. The
> > change you are suggesting will not affect the vmbus core which is what I want
> > to focus on. I will however, fix this issue in the current round of patches I will
> > send out this week.
> 
> It very clearly affects the interface between the core and the
> functional drivers.  Trying to submit the core without making sure the
> interface is exports works properly is not an overly good idea.

I must be missing something here. As I look at the block driver (and
this is indicative of other drivers as well); the exit routine -
blkvsc_drv_exit, first iterates through all the devices it manages
and invokes device_unregister() on each of the devices and then 
invokes vmbus_child_driver_unregister() which is just a wrapper on
driver_unregister(). So, if I understand you correctly, you want the devices to
persist even if there is no driver bound to them. So, if I eliminated the code
that iterates over the devices and unregisters them, that should fix the problem
and I can do this without changing the vmbus core interfaces.

Regards,

K. Y


