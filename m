Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab2JYHbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:31:03 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45445 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab2JYHbA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 25 Oct 2012 03:31:00 -0400
Message-Id: <508906CE02000078000A4553@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 25 Oct 2012 08:30:54 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <gregkh@linuxfoundation.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <virtualization@lists.linux-foundation.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [Xen-devel] linux-next: Tree for Oct 24 (xen)
References: <20121024151957.28a1626cd9a59c014e78c401@canb.auug.org.au>
 <50885EA8.3050007@xenotime.net>
In-Reply-To: <50885EA8.3050007@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.10.12 at 23:33, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 10/23/2012 09:19 PM, Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Changes since 201201023:
>> 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `dbgp_reset_prep':
> (.text+0xb96b5): undefined reference to `xen_dbgp_reset_prep'
> drivers/built-in.o: In function `dbgp_external_startup':
> (.text+0xb9d95): undefined reference to `xen_dbgp_external_startup'
> 
> 
> Full randconfig file is attached.

So this is because with !USB_SUPPORT but EARLY_PRINTK_DBGP
dbgp_reset_prep() and dbgp_external_startup() get pointlessly
defined and exported. This got broken by the merge
recommendation for the ARM side changes (originally compilation
of drivers/xen/dbgp.c depended on just CONFIG_XEN_DOM0).

>From my pov, fixing the USB side would be the clean solution (i.e.
putting those function definitions inside a CONFIG_USB_SUPPORT
conditional).

The alternative of a smaller change would be to extend the
conditional around the respective xen_dbgp_...() declarations
in include/linux/usb/ehci_def.h to become

#if defined(CONFIG_XEN_DOM0) && defined(CONFIG_USB_SUPPORT)

Please advise towards your preference.

Jan



