Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230Ab0KQSDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935136Ab0KQSDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:03:32 -0500
Date: Wed, 17 Nov 2010 13:03:21 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking
Message-ID: <20101117180320.GA13441@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
References: <201011162359.oAGNx3UN011130@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011162359.oAGNx3UN011130@hera.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:59:03PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/ec6743bb06510c7b629603ce35713d6ae9273579
 > Commit:     ec6743bb06510c7b629603ce35713d6ae9273579
 > Parent:     ca768b663131ca644689fcadc9ca092dcc96a758
 > Author:     Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
 > AuthorDate: Wed Nov 10 10:05:55 2010 +0100
 > Committer:  Martin Schwidefsky <sky@mschwide.boeblingen.de.ibm.com>
 > CommitDate: Wed Nov 10 10:05:54 2010 +0100
 > 
 >     [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking
 >     
 >     Provide the devmem_is_allowed() routine to restrict access to
 >     kernel memory from userspace.
 >     Set the CONFIG_STRICT_DEVMEM config option to switch on checking.
 >     
 >     Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
 >     Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

[snip add kconfig]

...

 > +static inline int devmem_is_allowed(unsigned long pfn)
 > +{
 > +	return 0;
 > +}

So you add the config option that promises security, but then you always
allow the access.  This seems pointless ?  Why bother having the option at all?

	Dave

