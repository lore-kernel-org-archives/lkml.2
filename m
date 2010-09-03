Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0ICSRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:17:10 -0400
Received: from [64.59.134.9] ([64.59.134.9]:54700 "EHLO idcmail-mo2no.shaw.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756948Ab0ICSRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:17:09 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=tAX36KLG1GoA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10
 a=xqWC_Br6kY4A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=ncr2pnT48pvA3gvVwXcA:9
 a=EVsboizwybUUDuckFoIA:7 a=EyAu1q0cfoyJjTcqfhuRoM_sqkkA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove of the general version
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <82mxrzrsvq.fsf@mid.bfk.de>
Date: Fri, 3 Sep 2010 12:16:57 -0600
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B1BAFDD8-BA1F-4C03-A19E-09DF91CD98FF@dilger.ca>
References: <4C7E2CAC.6080102@cn.fujitsu.com> <82mxrzrsvq.fsf@mid.bfk.de>
To: Florian Weimer <fweimer@bfk.de>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-03, at 05:03, Florian Weimer wrote:

> * Miao Xie:
> 
>> EXPORT_SYMBOL(memcpy);
> 
> I think you need to change that to EXPORT_SYMBOL_GPL, because the code
> is now licensed under the GPL, and not the GPL plus kernel exceptions
> (whatever they are, but they undoubtly exist), unlike the original
> implementation.

Ouch.  That would basically make it impossible to implement a non-GPL module.  Also, this should only apply to the "lib" version of the memcpy() routine, not the arch-specific ones that are written in assembly (maybe that already is true, I'm not sure).

Lustre is GPL, so it isn't fatal for us, but it definitely seems draconian, and almost a reason not to include this patch into the kernel.  Also, given that the original code is LGPL (which allows linking to non-GPL code) this seems counter to the intent of the original authors.

I suspect there isn't anything so brilliant in the glibc memcpy() that it couldn't be re-implemented without copying the code.  "implement memcpy with aligned machine-word-sized chunks" would be enough for anyone to reimplement it without ever having come close to the glibc code.

Cheers, Andreas





