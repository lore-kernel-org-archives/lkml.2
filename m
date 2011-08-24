Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1HXAzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:55:19 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:58684 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1HXAzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:55:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to protect
 the ext field in hv_device
Thread-Topic: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to
 protect the ext field in hv_device
Thread-Index: AQHMQxTVLTl5LitrmUaz4KIZG8xqLJUrwkMA//+mY9A=
Date: Wed, 24 Aug 2011 00:55:12 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B238B@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-81-git-send-email-kys@microsoft.com>
 <20110823230816.GN9641@kroah.com>
In-Reply-To: <20110823230816.GN9641@kroah.com>
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
> Sent: Tuesday, August 23, 2011 7:08 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to protect the
> ext field in hv_device
> 
> On Fri, Jul 15, 2011 at 10:47:09AM -0700, K. Y. Srinivasan wrote:
> > The current mechanism for handling references in broken.
> > Introduce a lock to protect the ext field in hv_device.
> 
> Why would that lock ever be needed?  How can things change to this
> pointer in different ways like you are thinking it could?  Doesn't the
> reference counting in the device itself handle this properly?

This is to deal with a potential race condition between the driver being
unloaded and incoming traffic from the VMBUS side. The ext pointer is 
device specific (either pointing to a storage or a network device) and what
we are protecting is the pointer being set to NULL from the unload side when
we might have a racing access from the interrupt side (on the incoming vmbus
traffic).

Regards,

K. Y 

