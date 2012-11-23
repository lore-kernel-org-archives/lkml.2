Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048Ab2KWJwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:52:46 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:37253 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161014Ab2KWJwo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 23 Nov 2012 04:52:44 -0500
Message-Id: <50AF55B102000078000AABF3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 23 Nov 2012 09:53:37 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <87lidwtego.fsf@xmission.com>
 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
 <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com>
 <50AEBF86.50501@citrix.com>
 <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
 <50AED7B8.7040902@citrix.com>
In-Reply-To: <50AED7B8.7040902@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.11.12 at 02:56, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> On 23/11/2012 01:38, H. Peter Anvin wrote:
>> I still don't really get why it can't be isolated from dom0, which would 
> make more sense to me, even for a Xen crash.
>>
> 
> The crash region (as specified by crashkernel= on the Xen command line)
> is isolated from dom0.
> 
> dom0 (using the kexec utility etc) has the task of locating the Xen
> crash notes (using the kexec hypercall interface), constructing a binary
> blob containing kernel, initram and gubbins, and asking Xen to put this
> blob in the crash region (again, using the kexec hypercall interface).
> 
> I do not see how this is very much different from the native case
> currently (although please correct me if I am misinformed).  Linux has
> extra work to do by populating /proc/iomem with the Xen crash regions
> boot (so the kexec utility can reference their physical addresses when
> constructing the blob), and should just act as a conduit between the
> kexec system call and the kexec hypercall to load the blob.

But all of this _could_ be done completely independent of the
Dom0 kernel's kexec infrastructure (i.e. fully from user space,
invoking the necessary hypercalls through the privcmd driver).
It's just that parts of the kexec infrastructure can be re-used
(and hence that mechanism probably seemed the easier approach
to the implementer of the original kexec-on-Xen). If the kernel
folks dislike that re-use (quite understandably looking at how
much of it needs to be re-done), that shouldn't prevent us from
looking into the existing alternatives.

Jan

