Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161084Ab2KWJz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:55:59 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45525 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2KWJz6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 23 Nov 2012 04:55:58 -0500
Message-Id: <50AF567402000078000AABF6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 23 Nov 2012 09:56:52 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <andrew.cooper3@citrix.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <kexec@lists.infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>, <konrad.wilk@oracle.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <87lidwtego.fsf@xmission.com>
 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
 <87txshx28b.fsf@xmission.com> <50AE62E9.3000602@zytor.com>
In-Reply-To: <50AE62E9.3000602@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.11.12 at 18:37, "H. Peter Anvin" <hpa@zytor.com> wrote:
> I actually talked to Ian Jackson at LCE, and mentioned among other 
> things the bogosity of requiring a PUD page for three-level paging in 
> Linux -- a bogosity which has spread from Xen into native.  It's a page 
> wasted for no good reason, since it only contains 32 bytes worth of 
> data, *inherently*.  Furthermore, contrary to popular belief, it is 
> *not* pa page table per se.
> 
> Ian told me: "I didn't know we did that, and we shouldn't have to." 
> Here we have suffered this overhead for at least six years, ...

Even the Xen kernel only needs the full page when running on a
64-bit hypervisor (now that we don't have a 32-bit hypervisor
anymore, that of course basically means always). But yes, I too
never liked this enforced over-allocation for native kernels (and
was surprised that it was allowed in at all).

Jan

