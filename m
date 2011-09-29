Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1I2NCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab1I2NCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:02:15 -0400
Subject: Re: [PATCH v3 00/24] C6X: New architecture
From: Mark Salter <msalter@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Thu, 29 Sep 2011 09:02:11 -0400
In-Reply-To: <60327.1317300157@turing-police.cc.vt.edu>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <22021.1317246541@turing-police.cc.vt.edu>
	 <201109291233.24623.arnd@arndb.de>
	 <1317298919.2580.92.camel@deneb.redhat.com>
	 <60327.1317300157@turing-police.cc.vt.edu>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317301332.2580.108.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 08:42 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 29 Sep 2011 08:21:58 EDT, Mark Salter said:
> 
> > One thing that we plan to push later is an XIP model where cores can share a
> > single kernel text image but run with their own copies of data. So you end up
> > with something like a loosely coupled multiprocessor system with some hardware
> > support for multicore communication and peripheral sharing.
> 
> Ah, OK.  I eventually came across a mention in one of the patches of running
> a separate instance of Linux on each core, whick left me even more mystified.
> But the above clarifies it, thanks...
> 
> I wonder how many currently global variables will need to be moved to per_cpu
> structures to make it work, and how intrusive that will end up.  Or is the plan
> to have the boot loader simply plonk the entire .data/.bss in different locations
> for each core?
> 

What we have prototyped is more like the latter. The XIP image (binary
kernel block) is in ROM. Bootloader boots the first core by jumping to
kernel image. Kernel copies initialized data to its reserved chunk of
RAM and runs from there. The other kernels can be started by the boot
kernel and they too will jump to the ROM image and make their own copies
of all data. Without cache coherency, sharing any cached data is
problematic.

Other models are also possible. For instance, other cores could run
dedicated DSP applications using some other minimal OS with HW supported
communication with the Linux OS acting as the overall manager.

--Mark



