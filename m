Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2KVSt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:49:29 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63565 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab2KVStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:49:25 -0500
X-IronPort-AV: E=Sophos;i="4.83,302,1352073600"; 
   d="scan'208";a="215291704"
Message-ID: <50AE69EF.4060909@citrix.com>
Date: Thu, 22 Nov 2012 18:07:43 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
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
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/12 17:47, H. Peter Anvin wrote:
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

I agree that regular guests should not be using the kexec/kdump. 
However, this patch series is required for allowing a pvops kernel to be
a crash kernel for Xen, which is very important from dom0/Xen's point of
view.

-- 
Andrew Cooper - Dom0 Kernel Engineer, Citrix XenServer
T: +44 (0)1223 225 900, http://www.citrix.com

