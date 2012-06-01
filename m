Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab2FAPdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:33:06 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34640 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab2FAPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:33:04 -0400
Date: Fri, 1 Jun 2012 08:33:02 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, akpm@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Message-ID: <552579991.43606.1338564781979.JavaMail.root@vmware.com>
In-Reply-To: <20120515235024.GB1758@kroah.com>
Subject: Re: [vmw_vmci RFC 00/11] VMCI for Linux
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.68.97.87]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC19 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Thanks so much for the comments and apologies for the delayed response.

> Don't we have something like this already for KVM and maybe Xen?
> virtio?  Can't you use that code instead of a new block of code that
> is only used by vmware users?  It has virtual pci devices which
> should give you what you want/need here, right?
>
> If not, why doesn't that work for you?  Would it be easier to just
> extend it?

The VMCI virtual device for which this driver is intended has been
around a lot longer than this submission might suggest.  The virtual
hardware was released in a product before Rusty sent his RFC and
quite a bit before it made it to mainline; there was, regrettably,
no virtio then.

As such, it was designed to be its own transport, and it's something
that is now very much fixed at the hardware level (enhancements
not withstanding), and which we have to support all the way back.

In addition to that, our hypervisor endpoints are written using
the existing device backend; virtio doesn't currently make a lot of
sense for them, and would require a lot of additional work.

All of this is unfortunate.  While I agree that virtio is certainly
the right approach, and we need to avoid this proliferation, I think
at this point we'd really like to try and upstream this in its current
form.  There's certainly the possibility going forwards that we could
add a glue layer, such that other clients could use virtio if they're
willing to write their own hypervisor endpoints.

Does that sound reasonable?

Again, many thanks for taking the time to review this.

Kind regards,
- Andy King
