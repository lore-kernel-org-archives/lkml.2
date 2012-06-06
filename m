Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2FFRci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:32:38 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8510 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2FFRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:32:37 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
In-Reply-To: <20120606162703.GA6779@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org> <1338999463.25761.630.camel@lyra>
	 <20120606162703.GA6779@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 11:32:36 -0600
Message-ID: <1339003956.25761.667.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 17:27 +0100, Matthew Garrett wrote:
> If the qla driver knows that this is safe, then can't this just be done 
> in the qla driver?
> 

That is one way of doing it. It makes for a safe change but potentially
leaves out a number of other cases that could be helped by wider scope
change of disabling Bus Master bit on all PCI devices, until we
laboriously debug every one of those cases and then add code to disable
Bus Master bit. Sounds to me like it is not a clear win in either case.

Do we agree that if device shutdown routine cleanly shuts down all I/O,
clearing PCI Bus Mster bit should be safe? If yes, then we only have to
deal with broken devices. So the approach could be to disable Bus Master
bit unless the device ID matches a blacklist which we update as we find
broken devices. I really don't like the idea of maintaining blacklists
in the kernel for such things but is that a more practical approach? If
blacklist does not sound good, maybe we can ask drivers to tell PCI
subsystem if they are not ok with clearing Bus Master bit and then PCI
subsystem could skip those devices.

-- 
Khalid
====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

