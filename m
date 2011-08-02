Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1HBIFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:05:46 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:42012 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1HBIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:05:39 -0400
Subject: Re: [patch v2 05/10] s390: Add PSW restart shutdown trigger
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110801205402.GK3805@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125808.172069159@linux.vnet.ibm.com>
	 <20110801205402.GK3805@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 02 Aug 2011 10:05:16 +0200
Message-ID: <1312272316.4881.4.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-08-01 at 16:54 -0400, Vivek Goyal wrote:
> On Wed, Jul 27, 2011 at 02:55:09PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > With this patch a new S390 shutdown trigger "restart" is added. If under
> > z/VM "systerm restart" is entered or under the HMC the "PSW restart" button
> > is pressed, the PSW located at 0 (31 bit) or 0x1a0 (64 bit) bit is loaded.
> > Now we execute do_restart() that processes the restart action that is
> > defined under /sys/firmware/shutdown_actions/on_restart. Currently the
> > following actions are possible: reipl (default), stop, vmcmd, dump, and
> > dump_reipl.
> 
> i know nothing about s390 but this sounds like a independent
> functionality? I mean defining a restart trigger and associated actions
> could be done even in current framework without kdump. IIUC, additional
> kdump series only adds the ability to use kdump for second kernel instead
> of using dump tools in case of "dump" or "dump_reipl" ?
> 
> If yes, then this patch probably does not have to be part of this series
> and pushed in independetly?

Yes, this is correct. We implemented the PSW restart functionality for
kdump, but it can be used independently.

We will integrate this patch upstream independently from this series.

Michael

