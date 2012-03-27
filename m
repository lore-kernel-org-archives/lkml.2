Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2C0WR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:17:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55292 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2C0WR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:17:26 -0400
Date: Wed, 28 Mar 2012 01:17:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20120327221721.GA3233@p183.telecom.by>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
 <1332748641.2836.8.camel@dabdike>
 <20120326140721.GA19827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326140721.GA19827@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 07:07:21AM -0700, Greg KH wrote:
> On Mon, Mar 26, 2012 at 08:57:21AM +0100, James Bottomley wrote:
> > On Mon, 2012-03-26 at 12:17 +1100, Stephen Rothwell wrote:
> > > Hi James,
> > > 
> > > After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > drivers/staging/keucr/scsiglue.c:349:2: error: unknown field 'proc_info' specified in initializer
> > > drivers/staging/rts_pstor/rtsx.c:258:2: error: unknown field 'proc_info' specified in initializer
> > > drivers/staging/rts5139/rts51x_scsi.c:2190:2: error: unknown field 'proc_info' specified in initializer
> > > 
> > > Caused by commit 104c4fe25dc9 ("[SCSI] remove scsi_host_template::proc_info").
> > > 
> > > Since this is a staging driver, I applied these following patches:
> > 
> > Yes, that looks about right, thanks.  We haven't seen anything about
> > these drivers on the SCSI list, so I've no idea where they are in
> > development.
> 
> Why is new patches going into your tree right now, during the 3.4 merge
> window?  API changes should have happened weeks ago, to let others fix
> up things like this.
> 
> As for the "where they are in development", they vary, but, a simple
> grep should have shown you that these in-kernel drivers should also be
> fixed up, or at the least, give me the heads up to let me do it for you.
> 
> Care to send me the patch that causes this problem so I can create a fix
> for this?

See commits 422f07001d6638fdde28f1909cc9162bc7f571d3..104c4fe25dc9bde823ba4591e910a77071b98ab5
Especially the first one.

Probably the best course of action is to remove proc_info code from
these drivers because the interface was deprecated for a long time.

The amount of code once removed from staging prevented me from doing
any work on them.

Looking at staging ->read_proc users this is going to be a problem for
its removal. :-(
