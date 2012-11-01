Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456Ab2KAUFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:05:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42992 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2KAUFC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 1 Nov 2012 16:05:02 -0400
Message-Id: <5092D5EA020000780008EB85@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 01 Nov 2012 20:04:58 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <rientjes@google.com>, <konrad.wilk@oracle.com>
Cc: <jeremy@goop.org>, <x86@kernel.org>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <xen-devel@lists.xensource.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [patch] x86, xen: fix build dependency when USB_SUPPORT is
 not enabled
References: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com>
 <20121101124912.GA10743@localhost.localdomain>
In-Reply-To: <20121101124912.GA10743@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 11/01/12 1:49 PM >>>
>On Wed, Oct 31, 2012 at 10:42:30PM -0700, David Rientjes wrote:
>> CONFIG_XEN_DOM0 must depend on CONFIG_USB_SUPPORT, otherwise there is no 
>> definition of xen_dbgp_reset_prep() and xen_dbgp_external_startup() 
>> resulting in the following link error:
>> 
>> drivers/built-in.o: In function `dbgp_reset_prep':
>> (.text+0x1e03c5): undefined reference to `xen_dbgp_reset_prep'
>> drivers/built-in.o: In function `dbgp_external_startup':
>> (.text+0x1e0d55): undefined reference to `xen_dbgp_external_startup'
>
>There is another patch that needs to be Acked and picked up by
>Greg KH that fixes this.
>
>Let me poke Jan Beulich to repost it with the appropiate Acks.

It's been picked up already, but another dependency problem was found with
it (due to not having used CONFIG_USB_SUPPORT as dependency, as I had
first submitted).

Jan

