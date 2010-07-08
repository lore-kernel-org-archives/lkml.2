Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0GHNAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:00:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0GHNAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:00:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
Date: Thu, 8 Jul 2010 15:00:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-14-git-send-email-arnd@arndb.de> <1278593415.3313.13.camel@localhost.localdomain>
In-Reply-To: <1278593415.3313.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081500.17647.arnd@arndb.de>
X-Provags-ID: V02:K0:ypHo1EMcUnE+RMWt3NqrLXKd9l7tPnfSMo9GddnmItj
 HK5OYBTWU6a9CpTM8M6f6O39FG+XPSrwpMyQVU8hpw81H0Ada9
 0WuK6ITapZ3EZxV7TZXIlAtj/qp3bdxZUKYD6gOL++/a6hhO+Q
 sGuoo4WD+2U80EWaYobPQ/U9/nwHh1S44zvinY8JOqXNxCugfU
 3DIL/2IJzmcrlwhJYtUjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Mimi Zohar wrote:
> On Wed, 2010-07-07 at 23:40 +0200, Arnd Bergmann wrote:
> > The default for llseek will change to no_llseek,
> > so securityfs users need to add explicit .llseek
> > assignments. Since we're dealing with regular
> > files from a VFS perspective, use generic_file_llseek.
> 
> As both the 'violations' and 'runtime_measurement_counts' are single
> values and 'policy' doesn't support read, this patch doesn't hurt, but
> adding .llseek is probably unnecessary.

Ok, thanks for the confirmation.

Are you applying the patch in your tree, or should I keep it in my
series?

Note that while it may not be necessary to add these specific .llseek
operations, the reason I'm doing it is because I want to provably
have a .llseek operation in every file_operation in the kernel before
the default gets changed.

	Arnd
