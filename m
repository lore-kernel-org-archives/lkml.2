Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab1KJLqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab1KJLqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:46:52 -0500
Date: Thu, 10 Nov 2011 12:47:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111110114732.GA2217@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
 <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
 <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110091816.GA2247@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomáš

On Thu, Nov 10, 2011 at 10:18:16AM +0100, Tomáš Janoušek wrote:
> On Wed, Nov 09, 2011 at 05:51:59PM +0100, Stanislaw Gruszka wrote:
> > I just discovered that CONFIG_DEBUG_PAGEALLOC does not work as expected.
> > It leave most of free pages unprotected, hence unintentional write to
> > them is not discovered. I'm attaching additional patch, which should
> > make detection actually work.
> > 
> > If kernel will does not boot with corrupt_dbg=1, you may try to catch
> > corruption without that option. Attached patch should make it possible,
> > however having corrupt_dbg=1 increase probability of the catch.
> 
> Okay, I applied this additional patch, and by the increased memory usage (as
> shown by free) I concluded that it indeed works. However, I was still able to
> reproduce the issue without a single error being written to dmesg. :-(
If "dmesg | grep corrupt" will show "Setting corrupt debug order to 1"
patches are in use. Anyway I need to test the patches locally, to see
if they work as expected, perhaps exception is generated but call-trace
is not printed.

Is this happen only with "Intel Corporation Centrino Advanced-N 6205" or
with some other adapters?

> I will try some really old kernels as Wey suggested to see whether it makes
> any sense to bisect it, but if it does, it might take more time than I can
> make free.
Yes, bisection is very time consuming, especially when reproducing
is not easy.

> Perhaps it would be cheaper to just get another card in that case.
> :-)
That will left issue unresolved :-(

Stanislaw
