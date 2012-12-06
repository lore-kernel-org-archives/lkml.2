Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946750Ab2LFSmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:42:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39681 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946405Ab2LFSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:42:09 -0500
Date: Thu, 6 Dec 2012 10:42:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Yang Wei <wei.yang@windriver.com>,
        Robert Richter <robert.richter@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jun Zhang <jun.zhang@intel.com>
Subject: Re: [ 09/56] x86-32: Fix invalid stack address while in softirq
Message-ID: <20121206184204.GE2862@kroah.com>
References: <20121130185118.302752929@linuxfoundation.org>
 <20121130185119.291181076@linuxfoundation.org>
 <20121204135646.GE2984@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204135646.GE2984@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 11:56:46AM -0200, Herton Ronaldo Krzesinski wrote:
> On Fri, Nov 30, 2012 at 10:55:01AM -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Robert Richter <robert.richter@amd.com>
> > 
> > commit 1022623842cb72ee4d0dbf02f6937f38c92c3f41 upstream.
> > 
> > In 32 bit the stack address provided by kernel_stack_pointer() may
> > point to an invalid range causing NULL pointer access or page faults
> > while in NMI (see trace below). This happens if called in softirq
> > context and if the stack is empty. The address at &regs->sp is then
> > out of range.
> > 
> > Fixing this by checking if regs and &regs->sp are in the same stack
> > context. Otherwise return the previous stack pointer stored in struct
> > thread_info. If that address is invalid too, return address of regs.
> > 
> 
> This also makes latest 3.4.y build fail with oprofile on i386, needs
> also EXPORT_SYMBOL for kernel_stack_pointer (commit
> cb57a2b4cff7edf2a4e32c0163200e9434807e0a)

Sorry, now fixed with 3.4.22
