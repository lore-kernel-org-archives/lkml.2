Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1HQNa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:30:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65422 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1HQNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:30:25 -0400
User-Agent: Microsoft-Entourage/12.30.0.110427
Date: Wed, 17 Aug 2011 14:30:12 +0100
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: prevent crash in
 xenwatch_thread() when stale watch events arrive
From: Keir Fraser <keir@xen.org>
To: Olaf Hering <olaf@aepfle.de>, Ian Campbell <Ian.Campbell@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Message-ID: <CA7180F4.307AF%keir@xen.org>
Thread-Topic: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: prevent crash in
 xenwatch_thread() when stale watch events arrive
Thread-Index: Acxc4cpm5b5frsFF50WemTEXGRCP/A==
In-Reply-To: <20110817125127.GA3163@aepfle.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/2011 13:51, "Olaf Hering" <olaf@aepfle.de> wrote:

> On Tue, Aug 16, Ian Campbell wrote:
> 
>> On Tue, 2011-08-16 at 14:16 +0100, Olaf Hering wrote:
>>> During repeated kexec boots xenwatch_thread() can crash because
>>> xenbus_watch->callback is cleared by xenbus_watch_path() if a node/token
>>> combo for a new watch happens to match an already registered watch from
>>> an old kernel.  In this case xs_watch returns -EEXISTS, then
>>> register_xenbus_watch() does not remove the to-be-registered watch from
>>> the list of active watches but returns the -EEXISTS to the caller
>>> anyway.
>> 
>> Isn't this behaviour the root cause of the issue (which should be fixed)
>> rather than papering over it during watch processing. IOW should't
>> register_xenbus_watch cleanup after itself if xs_watch fails.
> 
> Keir, the EEXISTS case in register_xenbus_watch() was added by you 6
> years ago. Do you happen to know what it tried to solve, and do these
> conditions still apply today?  Perhaps the EEXISTS can be removed now.
> 
> http://xenbits.xen.org/hg/xen-unstable.hg/diff/8016551fde98/linux-2.6-xen-spar
> se/drivers/xen/xenbus/xenbus_xs.c

Bad me. Either remove the EEXIST check, or convert EEXIST to return code 0
in register_xenbus_watch(). You could do either, since I'm sure I added the
EEXIST check only as an attempt to theoretically robustify that function,
and looks like I got it wrong.

 K.

> Olaf


