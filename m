Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1GGN4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:56:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:48638 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1GGN4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:56:04 -0400
Subject: Re: [PATCH v3 1/3] driver core: Add ability for arch code to setup pdev_archdata
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110701220900.GA28971@kroah.com>
Date: Thu, 7 Jul 2011 08:55:44 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <597354F4-D1D4-4BC0-9251-FDDC31B1E2A1@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org> <1308828839-27349-1-git-send-email-galak@kernel.crashing.org> <20110701220900.GA28971@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 1, 2011, at 5:09 PM, Greg KH wrote:

> On Thu, Jun 23, 2011 at 06:33:57AM -0500, Kumar Gala wrote:
>> On some architectures we need to setup pdev_archdata before we add the
>> device.  Waiting til a bus_notifier is too late since we might need the
>> pdev_archdata in the bus notifier.  One example is setting up of dma_mask
>> pointers such that it can be used in a bus_notifier.
>> 
>> We add noop version of arch_setup_pdev_archdata() in
>> <asm-generic/platform_device.h> and allow the arch code to override with
>> access the full definitions of struct device, struct platform_device, and
>> struct pdev_archdata.
> 
> Isn't there some way to use "weak" symbols to keep us from having to
> create this .h file in every single arch and then if the arch wants to
> define it, it does so?
> 
> That should make this patch simpler, right?
> 
> thanks,
> 
> greg k-h

Changing to weak should be doable if we are ok with the additional function call always happening.

- k

