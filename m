Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2JXM6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:58:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43485 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab2JXM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:58:36 -0400
Date: Wed, 24 Oct 2012 14:58:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tostatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86, add hypervisor name to dump_stack()
Message-ID: <20121024125829.GA22534@gmail.com>
References: <1349879268-3573-1-git-send-email-prarit@redhat.com>
 <20121024094944.GB4814@gmail.com>
 <5087DBD9.9010707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5087DBD9.9010707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> > Looks useful, but please don't waste a full new line on it 
> > but embedd it in the already existing status line that 
> > prints details like release and version.
> 
> Ingo, I thought about doing that but since x86_hyper can be 
> NULL (... maybe it should initialized to "Bare-metal" or "No 
> Hypervisor"?) I didn't want to break up the printk line.  I'll 
> look into doing it a different way...

You don't have to break it up - just initialize a name string 
to:

	const char *machine_name = "x86";
	const char *kernel_type = "native";

	if (x86_hyperv) {
		machine_name = x86_hyperv->name;
		kernel_type = "guest";
	}

And print it as:

          "[%s %s kernel]", machine_name, kernel_type

That way we'll get nice:

    ... [x86 native kernel]
    ... [KVM guest kernel]
    ... [Xen guest kernel]
    etc.

Printouts. Please use the naming I outlined above, that's how we 
refer to these kernels within arch/x86/.

(The above code is pseudocode, untested.)

Thanks,

	Ingo
