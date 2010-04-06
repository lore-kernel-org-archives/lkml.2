Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab0DFXVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:21:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57089 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0DFXVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:21:03 -0400
Subject: Re: [PATCH] VMware Balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
In-Reply-To: <4BBA7226.9080508@goop.org>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
	 <20100405142419.2c9bea3d.akpm@linux-foundation.org>
	 <4BBA5E1C.10706@goop.org>
	 <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
	 <4BBA7226.9080508@goop.org>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 16:20:59 -0700
Message-Id: <1270596059.32096.11895.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 16:28 -0700, Jeremy Fitzhardinge wrote:
> I guess a way to use it in the short term is to have a loop of the form:
> 
>         while (guest_size>  target) {
>                 shrink_all_memory(guest_size - target);         /* force pages to be free */
>                 while (p = alloc_page(GFP_NORETRY))             /* vacuum up pages */
>                         release_page_to_hypervisor(p);
>                 /* twiddle thumbs */
>         }

We also need to remember to consolidate the Xen and virtio-balloon
drivers.  They both have their own GFP flags, for instance, but I think
they actually want the exact same thing.  They could probably also share
that snippet, right?

-- Dave

