Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab0GHWxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:53:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:48938 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670Ab0GHWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:53:11 -0400
Date: Fri, 9 Jul 2010 08:52:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
In-Reply-To: <1278595102.3313.36.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1007090852200.23354@tundra.namei.org>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>  <1278538820-1392-14-git-send-email-arnd@arndb.de>  <1278593415.3313.13.camel@localhost.localdomain>  <201007081500.17647.arnd@arndb.de> <1278595102.3313.36.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, Mimi Zohar wrote:

> On Thu, 2010-07-08 at 15:00 +0200, Arnd Bergmann wrote:
> > On Thursday 08 July 2010, Mimi Zohar wrote:
> > > On Wed, 2010-07-07 at 23:40 +0200, Arnd Bergmann wrote:
> > > > The default for llseek will change to no_llseek,
> > > > so securityfs users need to add explicit .llseek
> > > > assignments. Since we're dealing with regular
> > > > files from a VFS perspective, use generic_file_llseek.
> > > 
> > > As both the 'violations' and 'runtime_measurement_counts' are single
> > > values and 'policy' doesn't support read, this patch doesn't hurt, but
> > > adding .llseek is probably unnecessary.
> > 
> > Ok, thanks for the confirmation.
> > 
> > Are you applying the patch in your tree, or should I keep it in my
> > series?
> 
> I'll leave that up to James.

I can take the patches, depends on what Arnd thinks is best.

> 
> > Note that while it may not be necessary to add these specific .llseek
> > operations, the reason I'm doing it is because I want to provably
> > have a .llseek operation in every file_operation in the kernel before
> > the default gets changed.
> > 
> > 	Arnd
> 
> Thanks for the clarification.
> 
> Mimi
> 

-- 
James Morris
<jmorris@namei.org>
