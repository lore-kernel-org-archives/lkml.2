Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0FHRZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:25:14 -0400
Received: from sous-sol.org ([216.99.217.87]:36117 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752800Ab0FHRZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:25:12 -0400
Date: Tue, 8 Jun 2010 10:24:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Matt Turner <mattst88@gmail.com>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.35-rc2 compilation error on Alpha
Message-ID: <20100608172434.GK8301@sequoia.sous-sol.org>
References: <4C0C22C4.3010705@orcon.net.nz>
 <AANLkTim9aWVzb7v5fnS6x3ghMU2_tpaLlbZu3SKXV_0R@mail.gmail.com>
 <4C0C47A8.1000800@orcon.net.nz>
 <AANLkTinnprvU7bbe28emifv766_tWKjaSfW0ch2PQY23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinnprvU7bbe28emifv766_tWKjaSfW0ch2PQY23@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Turner (mattst88@gmail.com) wrote:
> Fixes for both breaks are in:
>    git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
> for-linus

Your 83926ce2dd37e4337ecf53b1e435d08e70b5871b will work, but you can
also simply drop the filp from pci_mmap_resource().  That's an internal
helper (local to alpha/kernel/pci-sysfs.c) and doesn't require the filp.
Sorry, that was my fault, and should be localized to 2.6.35-rc.

> I know alpha hardware isn't easy to get your hands on to compile test
> these changes, but guys, please just send linux-alpha@ the patch and
> _I'll_ do it. Both these breaks were not even compile tested.
> 
> pci break: 2c3c8bea608866d8bd9dcf92657d57fdcac011c5

$ git describe --contains 2c3c8bea608866d8bd9dcf92657d57fdcac011c5
v2.6.35-rc1~459^2~9

> hweight break: 1527bc8b928dd1399c3d3467dd47d9ede210978a
> 
> Greg, I haven't checked, but if either of these commits are in .34 or
> older, then my fixes need to go into -stable.
