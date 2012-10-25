Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935747Ab2JYOFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:05:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35302 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935694Ab2JYOFr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 25 Oct 2012 10:05:47 -0400
Message-Id: <5089635702000078000A48D7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 25 Oct 2012 15:05:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [Xen-devel] linux-next: Tree for Oct 24 (xen)
References: <20121024151957.28a1626cd9a59c014e78c401@canb.auug.org.au>
 <50885EA8.3050007@xenotime.net>
 <508906CE02000078000A4553@nat28.tlf.novell.com>
 <alpine.DEB.2.02.1210251118010.2689@kaball.uk.xensource.com>
 <20121025134628.GE26209@localhost.localdomain>
In-Reply-To: <20121025134628.GE26209@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.10.12 at 15:46, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Thu, Oct 25, 2012 at 11:48:30AM +0100, Stefano Stabellini wrote:
>> On Thu, 25 Oct 2012, Jan Beulich wrote:
>> > >>> On 24.10.12 at 23:33, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > > On 10/23/2012 09:19 PM, Stephen Rothwell wrote:
>> > > 
>> > >> Hi all,
>> > >> 
>> > >> Changes since 201201023:
>> > >> 
>> > > 
>> > > on x86_64:
>> > > 
>> > > drivers/built-in.o: In function `dbgp_reset_prep':
>> > > (.text+0xb96b5): undefined reference to `xen_dbgp_reset_prep'
>> > > drivers/built-in.o: In function `dbgp_external_startup':
>> > > (.text+0xb9d95): undefined reference to `xen_dbgp_external_startup'
>> > > 
>> > > 
>> > > Full randconfig file is attached.
>> > 
>> > So this is because with !USB_SUPPORT but EARLY_PRINTK_DBGP
>> > dbgp_reset_prep() and dbgp_external_startup() get pointlessly
>> > defined and exported. This got broken by the merge
>> > recommendation for the ARM side changes (originally compilation
>> > of drivers/xen/dbgp.c depended on just CONFIG_XEN_DOM0).
>> > 
>> > >From my pov, fixing the USB side would be the clean solution (i.e.
>> > putting those function definitions inside a CONFIG_USB_SUPPORT
>> > conditional).
>> >
>> > The alternative of a smaller change would be to extend the
>> > conditional around the respective xen_dbgp_...() declarations
>> > in include/linux/usb/ehci_def.h to become
>> > 
>> > #if defined(CONFIG_XEN_DOM0) && defined(CONFIG_USB_SUPPORT)
>> > 
>> > Please advise towards your preference.
>> 
>> I think that your first suggestion is the right one.
> 
> Can you guys spin up a patch pls and make sure it does not break
> compilation. Thx.

I'd really like to hear Greg's opinion on which route to take before
pointlessly trying the other one.

Jan

