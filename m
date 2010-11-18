Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0KRI6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:58:41 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:35784 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0KRI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:58:40 -0500
Date: Thu, 18 Nov 2010 09:58:37 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        brueckner@linux.vnet.ibm.com
Subject: Re: [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking
Message-ID: <20101118095837.4ef7c563@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20101117180320.GA13441@redhat.com>
References: <201011162359.oAGNx3UN011130@hera.kernel.org>
	<20101117180320.GA13441@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 13:03:21 -0500
Dave Jones <davej@redhat.com> wrote:

> On Tue, Nov 16, 2010 at 11:59:03PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/ec6743bb06510c7b629603ce35713d6ae9273579
>  > Commit:     ec6743bb06510c7b629603ce35713d6ae9273579
>  > Parent:     ca768b663131ca644689fcadc9ca092dcc96a758
>  > Author:     Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
>  > AuthorDate: Wed Nov 10 10:05:55 2010 +0100
>  > Committer:  Martin Schwidefsky <sky@mschwide.boeblingen.de.ibm.com>
>  > CommitDate: Wed Nov 10 10:05:54 2010 +0100
>  > 
>  >     [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking
>  >     
>  >     Provide the devmem_is_allowed() routine to restrict access to
>  >     kernel memory from userspace.
>  >     Set the CONFIG_STRICT_DEVMEM config option to switch on checking.
>  >     
>  >     Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
>  >     Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> [snip add kconfig]
> 
> ...
> 
>  > +static inline int devmem_is_allowed(unsigned long pfn)
>  > +{
>  > +	return 0;
>  > +}
> 
> So you add the config option that promises security, but then you always
> allow the access.  This seems pointless ?  Why bother having the option at all?

It is the other way around, access is always disallowed. So it is very secure,
access via /dev/mem is disabled if STRICT_DEVMEM=y.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

