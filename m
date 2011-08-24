Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1HXAiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:38:15 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:13036 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HXAiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:38:11 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Thread-Topic: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Thread-Index: AQHMQxmwelNZej0M8Ey5TPtGzUjq3JUrvP0A//+izUA=
Date: Wed, 24 Aug 2011 00:38:09 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B2356@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-19-git-send-email-kys@microsoft.com>
 <20110823224932.GF9641@kroah.com>
In-Reply-To: <20110823224932.GF9641@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 23, 2011 6:50 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
> 
> On Fri, Jul 15, 2011 at 10:46:07AM -0700, K. Y. Srinivasan wrote:
> > Now generate appropriate uevent based on the modalias string. As part of this,
> > cleanup the existing uevent code.
> 
> Note, you just change the user api here, did you have tools that relied
> on the old format?  If so, they just broke :(

Prior to this, I don't think autoloading worked the way it should for these
modules. 

> 
> > +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
> > +		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
> 
> Don't we have a type for printing out a uuid already?

I did not see one; could you point me to the right place.
> 
> And what's with the jumping by 2 yet dividing?  What am I missing here?

Each byte of the uuid is represented by 2 bytes in the string; thus the magic with 2.

Regards,

K. Y

