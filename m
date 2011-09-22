Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1IVLLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:11:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:62794 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1IVLLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:11:03 -0400
Date: Thu, 22 Sep 2011 07:10:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110922111046.GC7233@phenom.oracle.com>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
 <20110922104902.GA23513@phenom.oracle.com>
 <20110922105706.GC4051@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922105706.GC4051@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E7B17B9.004D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 06:57:06AM -0400, Neil Horman wrote:
> On Thu, Sep 22, 2011 at 06:49:02AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Mon, Sep 19, 2011 at 11:47:15AM -0400, Neil Horman wrote:
> > > So a while back, I wanted to provide a way for irqbalance (and other apps) to
> > > definitively map irqs to devices, which, for msi[x] irqs is currently not really
> > > possible in user space.  My first attempt wen't not so well:
> > > https://lkml.org/lkml/2011/4/21/308
> > > 
> > > It was plauged by the same issues that prior attempts were, namely that it
> > > violated the one-file-one-value sysfs rule.  I wandered off but have recently
> > > come back to this.  I've got a new implementation here that exports a new
> > > subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
> > > a variable number of numbered subdirectories, in which the number represents an
> > > msi irq.  Each numbered subdirectory contains attributes for that irq, which
> > > currently is only the mode it is operating in (msi vs. msix).  I think fits
> > > within the constraints sysfs requires, and will allow irqbalance to properly map
> > > msi irqs to devices without having to rely on rickety, best guess methods like
> > > interface name matching.
> > 
> > Are there irqbalance patches that correspond to this? Where would they be available?
> > 
> I've got them here locally, shemminger and I are testing them out, when I'm comfortable with
> them, I'll be comitting them to the public repository at code.google.com

Right.. asking b/c it might be a good idea to include that in the git
description of the patch.

BTW, I also had some question on the patch itself - not sure if you had a chance
to read them.
> 
> Note, the changes to support this kernel update in irqbalance is also comming
> with a major gutting that I'm doing of the daemon.  Things like making workload
> bias adjustments based on packets received per interface, since theres no
> guaranteed 1:1 correlation between network interfaces and irqs.  The point being
> that while irq identification will definately be fixed, you might notice other
> behavioral differences that we may or may not want to address.  Bug reports
> would be greatly appreciated at the project site.
> 
> Thanks!
> Neil
