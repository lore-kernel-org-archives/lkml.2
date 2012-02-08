Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2BHCAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:00:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35639 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410Ab2BHCAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:00:42 -0500
X-Sasl-enc: ks73IP3U3ZUcFskOKyACw1kj/Fp4bLrWlJKFWXQGAHrp 1328666441
Date: Wed, 8 Feb 2012 00:00:38 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Subject: Re: network regression: cannot rename netdev twice
Message-ID: <20120208020038.GE13296@khazad-dum.debian.net>
References: <4F27120A.4040106@suse.cz>
 <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz>
 <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
 <20120204021457.GA25386@khazad-dum.debian.net>
 <CAPXgP12yZ74679JNwRB-pDfnjOBaxMzL2=krSDK31jM1mjXfuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP12yZ74679JNwRB-pDfnjOBaxMzL2=krSDK31jM1mjXfuA@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Feb 2012, Kay Sievers wrote:
> On Sat, Feb 4, 2012 at 03:14, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > Is it possible to configure the kernel to use something other than "eth#" as
> > its initial namespace for netif names?  Or is there some other way to get
> > eth1 to be what you need eth1 to be during userland boot?
> 
> I don't think there is a sane way to do that. Someone could add a
> kernel command line parameter to switch ethX in the kernel to
> something else, and create custom udev rules which match on device
> properties and apply configured names which are ethX again. But for
> all that, there will be no generally available support in common base
> system tools, and we absolutely do not recommend anybody doing that.

What sort of impact analysis on userspace was done about this change?

Nobody in his right mind would go back to the dark ages of uncontrolled
ifnames.  You're effectively forcing everybody with a clue away from the
eth# namespace.

Just to be very clear: the impact of this is the need to change the
interface names on potentially millions of lines of firewall rules and
scripts out there, as well as tracking down stuff (mostly scripts) that
special-cases the eth prefix.

Is there a really good reason why we cannot have a way to move the
kernel away from the eth# namespace at boot (through a kernel parameter,
maybe with the default namespace set at compile time), AND keep the
"common base system tools" support to assign ifname based on MAC
addresses that we have right now?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
