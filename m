Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1KGMn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:43:59 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:57587 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab1KGMn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:43:57 -0500
Date: Mon, 7 Nov 2011 07:43:51 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to
 test kernels
Message-ID: <20111107124351.GB24685@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <4EB67D17.7000701@redhat.com>
 <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
 <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
 <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
 <4EB7B1A9.9000409@redhat.com>
 <CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com>
 <4EB7CE71.50401@redhat.com>
 <CAOJsxLEMdmWH06Dd+g4SkuG8H9iGwdBMSQYthMYtF9eyC2p9Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEMdmWH06Dd+g4SkuG8H9iGwdBMSQYthMYtF9eyC2p9Ew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:29:45PM +0200, Pekka Enberg wrote:
> So what do you think about perf then? The amount of code that talks to
> the kernel is much smaller than that of the KVM tool.

I think it's a mess, because it's never clear whether perf needs to be
upgraded when I upgrade the kernel, or vice versa.  This is why I keep
harping on the interface issues.

Fortunately it seems less likely (since perf doesn't run with
privileges) that security fixes will need to be released for perf, but
if it did, given the typical regression testing requirements that many
distributions have, and given that most distro packaging tools assume
that all binaries from a single source package come from a single
version of that source package, I predict you will hear screams from
the distro release engineers.

And by the way, there are use cases, where the guest OS kernel and
root on the guest OS are not available to the untrusted users, where
the userspace KVM program would be part of the security perimeter, and
were security releases to the KVM part of the tool might very well be
necessary, and it would be unfortunate if that forced the release of
new kernel packages each time security fixes are needed to the
kvm-tool userspace.  Might kvm-tool be more secure than qemu?  Quite
possibly, given that it's going to do less than qemu.  But please note
that I've not been arguing that kvm-tool shouldn't be done; just that
it not be included in the kernel sources.

Just as sparse is not bundled into the kernel sources, for crying out
loud!

						- Ted
