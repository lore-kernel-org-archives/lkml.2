Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0FHHww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:52:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54041 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628Ab0FHHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:52:51 -0400
Date: Tue, 8 Jun 2010 09:01:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100608090120.75bf7c80@lxorguk.ukuu.org.uk>
In-Reply-To: <000601cb06cd$f48d3bb0$66f8800a@maildom.okisemi.com>
References: <4C0DCE87.1090802@dsn.okisemi.com>
	<000601cb06cd$f48d3bb0$66f8800a@maildom.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 14:46:31 +0900
"Masayuki Ohtake" <masa-korg@dsn.okisemi.com> wrote:

> Hi Alan
> 
> > > Remember here ioctl isn't single threaded so you may want to double check
> >
> > > some of these
> >
> > The above copy_from_user is Copy global variable to local variable.
> > Thus, We think this code has re-entrant.
> The above is not true.
> Our ioctl routine is just used under single pthread.

What if someone else chooses to open it and run multiple threads through
it. What if the code changes. What about malicious attempts to confuse
the driver ?

The fact your own current userspace does not do this does not mean it can
be ignored.

Alan
