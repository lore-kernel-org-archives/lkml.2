Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab0EZU7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:59:31 -0400
Received: from claw.goop.org ([74.207.240.146]:58220 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab0EZU7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:59:30 -0400
Message-ID: <4BFD8BB0.90301@goop.org>
Date: Wed, 26 May 2010 13:59:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 11/11] Unplug emulated disks and nics
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC3390.4060503@goop.org> <alpine.DEB.2.00.1005261325110.25605@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1005261325110.25605@kaball-desktop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 05:27 AM, Stefano Stabellini wrote:
> It is needed for LINUX_VERSION_CODE, see below:
>
>   
>>> +
>>> +#define XEN_IOPORT_MAGIC_VAL 0x49d2
>>> +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
>>> +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
>>>       

Ah.  What's that for?  Does qemu change its behaviour depending on the
kernel version?  Ah, something to do with blacklisting.  But is the
Linux kernel version the most useful value here?  Shouldn't there be
some kind of separate version number?  And what's the blacklisting stuff
for anyway?

Wow, this interface is perverse.  It reuses the same IO port but changes
function depending on the size of the IO?  Again, wow.

    J
