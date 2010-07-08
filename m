Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0GHNSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:18:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55016 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab0GHNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:18:39 -0400
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
In-Reply-To: <201007081500.17647.arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	 <1278538820-1392-14-git-send-email-arnd@arndb.de>
	 <1278593415.3313.13.camel@localhost.localdomain>
	 <201007081500.17647.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 09:18:22 -0400
Message-ID: <1278595102.3313.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 15:00 +0200, Arnd Bergmann wrote:
> On Thursday 08 July 2010, Mimi Zohar wrote:
> > On Wed, 2010-07-07 at 23:40 +0200, Arnd Bergmann wrote:
> > > The default for llseek will change to no_llseek,
> > > so securityfs users need to add explicit .llseek
> > > assignments. Since we're dealing with regular
> > > files from a VFS perspective, use generic_file_llseek.
> > 
> > As both the 'violations' and 'runtime_measurement_counts' are single
> > values and 'policy' doesn't support read, this patch doesn't hurt, but
> > adding .llseek is probably unnecessary.
> 
> Ok, thanks for the confirmation.
> 
> Are you applying the patch in your tree, or should I keep it in my
> series?

I'll leave that up to James.

> Note that while it may not be necessary to add these specific .llseek
> operations, the reason I'm doing it is because I want to provably
> have a .llseek operation in every file_operation in the kernel before
> the default gets changed.
> 
> 	Arnd

Thanks for the clarification.

Mimi

