Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757Ab1JENaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:30:04 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:11281 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700Ab1JENaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:30:03 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Long Li <longli@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: util: Fix a bug in kvp implementation
Thread-Topic: [PATCH 1/1] Staging: hv: util: Fix a bug in kvp implementation
Thread-Index: AQHMgtqYGRBe1fkw0ECG1621D/vf1ZVtoI+AgAAcNvA=
Date: Wed, 5 Oct 2011 13:30:01 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081EBC4D@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1317762002-4351-1-git-send-email-kys@microsoft.com>
 <20111005043717.GA3918@suse.de>
In-Reply-To: <20111005043717.GA3918@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, October 05, 2011 12:37 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Long Li; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: util: Fix a bug in kvp implementation
> 
> On Tue, Oct 04, 2011 at 02:00:02PM -0700, K. Y. Srinivasan wrote:
> > The host gurantees that there can be only one kvp transaction active
> > against the guest. So, the transaction active state is needed only to
> > protect against spurious user level calls. The current code had a race
> > condition where the guest could prematurely return because the previous
> > transaction state was not cleared - this state was being cleared after
> > sending the response to the host and there was a window where the host
> > could notify the guest of a new transaction before the transaction active
> > state was properly set.
> > Also deal with the case when the user mode component
> > does not respond in a timely fashion correctly.
> > I would like to thank Long Li <longli@microsoft.com>
> > for identifying the problem.
> 
> So that would be a "Reported-by:" tag, we don't have a "Diagnosed-by" do
> we?

Reported-by tag would do.
> 
> And should this go to the older (i.e. stable) kernels as well?
> 

While the bug can be triggered by doing something that is not the way this (KVP) 
feature is to be used, I don't think this bug can be triggered under normal usage.
The test case that exposed this bug was one where KVP values were being queried
from the host in a tight loop - hardly a typical usage scenario. So, I was not sure if this would
qualify for back porting to other stable kernels. What do you think?

Regards,

K. Y

