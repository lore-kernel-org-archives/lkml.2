Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab2CUQYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab2CUQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:24:51 -0400
Date: Wed, 21 Mar 2012 18:24:38 +0200
From: Gleb Natapov <gleb@redhat.com>
To: minyard@acm.org
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120321162437.GB12300@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F6854F4.3060703@cn.fujitsu.com>
 <20120320154517.GG27928@redhat.com>
 <4F692723.8050904@cn.fujitsu.com>
 <20120321091127.GO22368@redhat.com>
 <4F69FF48.3010200@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F69FF48.3010200@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:18:16AM -0500, Corey Minyard wrote:
> 
> >Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
> >event over IMPI. The code is pretty complex. Of course if we a going to
> >implement something more complex than simple hypercall for panic
> >notification we better do something more interesting with it than just
> >saying "panic happened", like sending stack traces on all cpus for
> >instance.
> 
> I doubt that's the best example, unfortunately.  The IPMI event log
> has limited space and it has to be send a little piece at a time
> since each log entry is 14 bytes.  It just prints the panic string,
> nothing else.  Not that it isn't useful, it has saved my butt
> before.
> 
I gave ipmi example just to show that others do complex things on panic,
not as an example of what we should do on a guest panic.

> You have lots of interesting options with paravirtualization.  You
> could, for instance, create a console driver that delivered all
> console output efficiently through a hypercall.  That would be
> really easy.  Or, as you mention, a custom way to deliver panic
> information.  Collecting information like stack traces would be
> harder to accomplish, as I don't think there is currently a way to
> get it except by sending it to printk.
> 
Why using hypercall for that though? You can do that with
virtio-console. Make it zero config: virtio-console detected -> send
console output there.

--
			Gleb.
