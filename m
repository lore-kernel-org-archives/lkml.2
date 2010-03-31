Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0CaWBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:01:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40368 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0CaWBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:01:31 -0400
Message-ID: <4BB3C540.9000405@zytor.com>
Date: Wed, 31 Mar 2010 14:57:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org> <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org> <alpine.DEB.2.00.1003311640410.30456@router.home> <20100331215411.GB17715@flint.arm.linux.org.uk>
In-Reply-To: <20100331215411.GB17715@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 02:54 PM, Russell King wrote:
> On Wed, Mar 31, 2010 at 04:42:25PM -0500, Christoph Lameter wrote:
>> Do not run the checks while we are in a single threaded context?
>>
>> I thought we had some dynamic code patching thingamy that could change
>> those when we go to smp mode?
> 
> You have to remember that on embedded architectures, such as ARM,
> where XIP is supported we can't change the text segment at run time -
> which means dynamic code patching won't work.
> 
> However, the kernel should still work in such situations.
> 

The question still remains what the incremental cost is of doing
irqsave/irqrestore.

	-hpa
