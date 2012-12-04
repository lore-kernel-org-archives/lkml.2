Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2LDN4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:56:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2LDN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:56:52 -0500
Date: Tue, 4 Dec 2012 11:56:46 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Yang Wei <wei.yang@windriver.com>,
        Robert Richter <robert.richter@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jun Zhang <jun.zhang@intel.com>
Subject: Re: [ 09/56] x86-32: Fix invalid stack address while in softirq
Message-ID: <20121204135646.GE2984@herton-Z68MA-D2H-B3>
References: <20121130185118.302752929@linuxfoundation.org>
 <20121130185119.291181076@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130185119.291181076@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:55:01AM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Robert Richter <robert.richter@amd.com>
> 
> commit 1022623842cb72ee4d0dbf02f6937f38c92c3f41 upstream.
> 
> In 32 bit the stack address provided by kernel_stack_pointer() may
> point to an invalid range causing NULL pointer access or page faults
> while in NMI (see trace below). This happens if called in softirq
> context and if the stack is empty. The address at &regs->sp is then
> out of range.
> 
> Fixing this by checking if regs and &regs->sp are in the same stack
> context. Otherwise return the previous stack pointer stored in struct
> thread_info. If that address is invalid too, return address of regs.
> 

This also makes latest 3.4.y build fail with oprofile on i386, needs
also EXPORT_SYMBOL for kernel_stack_pointer (commit
cb57a2b4cff7edf2a4e32c0163200e9434807e0a)

-- 
[]'s
Herton
