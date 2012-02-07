Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2BGASB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:18:01 -0500
Received: from mail.vyatta.com ([76.74.103.46]:47028 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab2BGAR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:17:59 -0500
Date: Mon, 6 Feb 2012 16:17:57 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Sudden kernel panic with skge in 3.3-rc2
Message-ID: <20120206161757.6eac9277@nehalam.linuxnetplumber.net>
In-Reply-To: <CAP=VYLp6Kh7OtN0nsTBDkvTvNLMV0jymAmbR0tJX4r-yMdTSQA@mail.gmail.com>
References: <20120202192115.GA8480@elliptictech.com>
	<20120202124529.3e274223@s6510.linuxnetplumber.net>
	<CAP=VYLp6Kh7OtN0nsTBDkvTvNLMV0jymAmbR0tJX4r-yMdTSQA@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 19:11:27 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> On Thu, Feb 2, 2012 at 3:45 PM, Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> [...]
> 
> >
> > Try reverting this commit, it seems problematic
> > commit d0249e44432aa0ffcf710b64449b8eaa3722547e
> > Author: stephen hemminger <shemminger@vyatta.com>
> > Date:   Thu Jan 19 14:37:18 2012 +0000
> >
> >    skge: check for PCI dma mapping errors
> >
> 
> I'm seeing similar issues, and a revert of the above caused the
> problems to go away.  I'm testing on a baseline of net-next
> as of today (3238a9be4d7a) plus some TIPC patches I was
> trying to test (which are 99.9% unrelated to this, I'm sure).
> 
> Details captured from serial console are below.  100% reproducible.
> 
> I can probably try a test/debug patch for you if need be.
> 
> Paul.

There is a simple bug in the cleanup code reordering. And it is
reproducible here. Working on a better solution.
