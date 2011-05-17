Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1EQWxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:53:22 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:14157 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab1EQWxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:53:21 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 2/2] Connector: Correctly set the error code in case of
 success when dispatching receive callbacks
Thread-Topic: [PATCH 2/2] Connector: Correctly set the error code in case of
 success when dispatching receive callbacks
Thread-Index: AQHMFN9rqew3bn7EnkOUOmjVfRcrF5SSEA2A//+NvVA=
Date: Tue, 17 May 2011 22:53:18 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FB74C@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1305671138-19443-1-git-send-email-kys@microsoft.com>
 <1305671138-19443-2-git-send-email-kys@microsoft.com>
 <20110517223155.GC15741@kroah.com>
In-Reply-To: <20110517223155.GC15741@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, May 17, 2011 6:32 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 2/2] Connector: Correctly set the error code in case of
> success when dispatching receive callbacks
> 
> On Tue, May 17, 2011 at 03:25:38PM -0700, K. Y. Srinivasan wrote:
> > The recent changes to the connector code introduced this bug where even
> > when a callback was invoked, we would return an error resulting in
> > double freeing of the skb. This patch fixes this bug.
> 
> By "recent" what do you mean?  Is this something that is in the .39
> kernel?  Do you have a git commit id that caused this?
> 
> Or is this due to changes that are queued up for the .40 merge window?

I just happened to test KVP functionality yesterday on latest bits from your tree (NEXT)
and discovered that whenever  something was sent to the kernel from userland on a 
connector channel, the system would hang. The following commit appears to be where
this bug was introduced:

commit 04f482faf50535229a5a5c8d629cf963899f857c
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Mar 28 08:39:36 2011 +0000

Since prior to this commit I don't see this problem. In any event the current code is clearly
broken.

Regards,

K. Y

