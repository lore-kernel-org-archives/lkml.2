Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2KWAW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:22:59 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:44058 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2KWAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:22:58 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 19:22:57 EST
X-IronPort-AV: E=Sophos;i="4.83,303,1352073600"; 
   d="scan'208";a="15963759"
Message-ID: <50AEBF86.50501@citrix.com>
Date: Fri, 23 Nov 2012 00:12:54 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com> <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com> <87lidwtego.fsf@xmission.com> <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl> <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com>
In-Reply-To: <50AE6542.3020302@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/2012 17:47, H. Peter Anvin wrote:
> The other thing that should be considered here is how utterly 
> preposterous the notion of doing in-guest crash dumping is in a system 
> that contains a hypervisor.  The reason for kdump is that on bare metal 
> there are no other options, but in a hypervisor system the right thing 
> should be for the hypervisor to do the dump (possibly spawning a clean 
> I/O domain if the I/O domain is necessary to access the media.)
>
> There is absolutely no reason to have a crashkernel sitting around in 
> each guest, consuming memory, and possibly get corrupt.
>
> 	-hpa
>

(Your reply to my email which I can see on the xen devel archive appears
to have gotten lost somewhere inside the citrix email system, so
apologies for replying out of order)

The kdump kernel loaded by dom0 is for when Xen crashes, not for when
dom0 crashes (although a dom0 crash does admittedly lead to a Xen crash)

There is no possible way it could be a separate domain; Xen completely
ceases to function as soon as jumps to the entry point of the kdump image.

~Andrew
