Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1AROv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:51:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1AROv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:51:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: pratyush <pratyush.anand@st.com>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
Date: Tue, 18 Jan 2011 15:51:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Viresh KUMAR <viresh.kumar@st.com>, Greg KH <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com> <201101072332.16985.arnd@arndb.de> <4D2AEB84.6060804@st.com>
In-Reply-To: <4D2AEB84.6060804@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181551.47675.arnd@arndb.de>
X-Provags-ID: V02:K0:VDQ360UU+0pLSvtbEVp6oLquy/dGj5wM/mCAtAnKIL6
 ba7anx2fi4lvaFIkFbQirdmRIMn6JCd735nwIYJQLn7hXOHGoK
 da0Ss3aRas46Z5t803+hcqlklCrtmo0chpMq58X2ASRHAkQWUW
 RZ+vCbiKcI+TzpBUr7cOYSnlaqmgKwe4uU9bWylLgz+oyaB1r/
 qMPvkgAgR/uWBLYO/fRgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 January 2011, pratyush wrote:

> >> +/*wait till link is up*/
> >> +# cat sys/devices/platform/pcie-gadget-spear.0/link
> >> +wait till it returns UP.
> > 
> > A blocking sysfs read is not a nice interface. This is probably where
> > the sysfs abstraction for your hardware stops making sense.
> > 
> 
> This call is not blocking. User will have to recheck link status till he
> finds it UP. He may put some delay between two successive read. I will
> modify documentation to be more explicit.

Ok, that is better, although with this interface you could argue that having
a blocking interface (not a sysfs file) would be useful to have.

> > The user interface for the interrupts looks to me like it should really
> > be based around a character device and either read/write/poll or
> > ioctl and poll. Using an eventfd might be cool here, because  then you
> > can combine this with other devices by passing the event file to
> > an interface that operates on eventfd. This would e.g. make it possible
> > to combine a UIO device generating interrupts with a PCIe gadget
> > sending the interrupts somewhere else, without leaving kernel
> > space.
> > 
> 
> I do not have much idea about eventfd mechanism. But if we decide to
> split it in two layers (generic pcie gadget and HW specific) then I
> might try to do it in this way.
 
ok.

	Arnd
