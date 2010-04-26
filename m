Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0DZVxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:53:52 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58370 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751118Ab0DZVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:53:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RSl9sadfGWtN5ioY2d22QQhIUA0SWtYivAWCYADJU6T3Am2CdOkcz1Djx8QDkxlSyofw8PhBcdwLLH58V4TgAYeZhzp+JyWMiymXuCuvP/tCyfgIqmSHU6Oy7Iia4qQ2;
Date: Mon, 26 Apr 2010 14:53:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below  
 BIOS_END
Message-ID: <20100426145352.01575798@virtuousgeek.org>
In-Reply-To: <2b9433aea407fa99bfc3fba10cc6fb8e.squirrel@www.zytor.com>
References: <4BC4E55B.7000103@oracle.com>
	<20100426183436.GV11130@hexapodia.org>
	<20100426123135.5d095d2f@virtuousgeek.org>
	<201004261427.57229.bjorn.helgaas@hp.com>
	<20100426133757.3e1d0a75@virtuousgeek.org>
	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
	<20100426142546.2e77b1ba@virtuousgeek.org>
	<2b9433aea407fa99bfc3fba10cc6fb8e.squirrel@www.zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 14:44:50 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> >
> > Agreed.  The trickier part is handling any platform devices that
> > request_resource against that space.  But maybe we don't need to do
> > anything special; just making sure we avoid it in the PCI "BIOS" code
> > as Bjorn did may be sufficient.
> >
> 
> Why is that hard?  If a platform device does a request_resource against
> that space, it's a request for specific address space and it should be
> granted.

I was thinking if we made it a special resource type we'd have to
change any platform drivers to use it; i.e. it wouldn't be
IORESOURCE_MEM or IORESOURCE_IO but IORESOURCE_DRAGONS.  That way it
wouldn't be part of the normal resource space.

But that's definitely overkill.  I think Bjorn's fix is sufficient.

-- 
Jesse Barnes, Intel Open Source Technology Center
