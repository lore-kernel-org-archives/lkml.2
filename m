Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab1GHEDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:03:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:38377 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GHEDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:03:52 -0400
Subject: Re: [PATCH v3 1/3] driver core: Add ability for arch code to setup pdev_archdata
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110707141125.GE27648@kroah.com>
Date: Thu, 7 Jul 2011 23:03:44 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5F42C27F-25F0-4E3C-AFED-4662D57B1A88@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org> <1308828839-27349-1-git-send-email-galak@kernel.crashing.org> <20110701220900.GA28971@kroah.com> <597354F4-D1D4-4BC0-9251-FDDC31B1E2A1@kernel.crashing.org> <20110707141125.GE27648@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7, 2011, at 9:11 AM, Greg KH wrote:

> On Thu, Jul 07, 2011 at 08:55:44AM -0500, Kumar Gala wrote:
>> 
>> On Jul 1, 2011, at 5:09 PM, Greg KH wrote:
>> 
>>> On Thu, Jun 23, 2011 at 06:33:57AM -0500, Kumar Gala wrote:
>>>> On some architectures we need to setup pdev_archdata before we add the
>>>> device.  Waiting til a bus_notifier is too late since we might need the
>>>> pdev_archdata in the bus notifier.  One example is setting up of dma_mask
>>>> pointers such that it can be used in a bus_notifier.
>>>> 
>>>> We add noop version of arch_setup_pdev_archdata() in
>>>> <asm-generic/platform_device.h> and allow the arch code to override with
>>>> access the full definitions of struct device, struct platform_device, and
>>>> struct pdev_archdata.
>>> 
>>> Isn't there some way to use "weak" symbols to keep us from having to
>>> create this .h file in every single arch and then if the arch wants to
>>> define it, it does so?
>>> 
>>> That should make this patch simpler, right?
>>> 
>>> thanks,
>>> 
>>> greg k-h
>> 
>> Changing to weak should be doable if we are ok with the additional
>> function call always happening.
> 
> Given that this is not a fast path, and the function call for the
> "normal" case would do nothing, it should be fine, right?
> 
> greg k-h

Sounds good, new version sent that uses weak instead.  If this looks good let me know if you just want to ACK and send via powerpc.git tree or if you'll pick these up.

- k


