Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2KWB4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:56:14 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:1209 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2KWB4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:56:10 -0500
X-IronPort-AV: E=Sophos;i="4.83,304,1352073600"; 
   d="scan'208";a="15964046"
Message-ID: <50AED7B8.7040902@citrix.com>
Date: Fri, 23 Nov 2012 01:56:08 +0000
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
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com> <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com> <87lidwtego.fsf@xmission.com> <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl> <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com> <50AEBF86.50501@citrix.com> <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
In-Reply-To: <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/2012 01:38, H. Peter Anvin wrote:
> I still don't really get why it can't be isolated from dom0, which would make more sense to me, even for a Xen crash.
>

The crash region (as specified by crashkernel= on the Xen command line)
is isolated from dom0.

dom0 (using the kexec utility etc) has the task of locating the Xen
crash notes (using the kexec hypercall interface), constructing a binary
blob containing kernel, initram and gubbins, and asking Xen to put this
blob in the crash region (again, using the kexec hypercall interface).

I do not see how this is very much different from the native case
currently (although please correct me if I am misinformed).  Linux has
extra work to do by populating /proc/iomem with the Xen crash regions
boot (so the kexec utility can reference their physical addresses when
constructing the blob), and should just act as a conduit between the
kexec system call and the kexec hypercall to load the blob.

For within-guest kexec/kdump functionality, I agree that it is barking
mad.  However, we do see cloud operators interested in the idea so VM
administrators can look after their crashes themselves.

~Andrew
