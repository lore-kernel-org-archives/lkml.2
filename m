Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0JNVYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:24:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40451 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab0JNVYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:24:44 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Date: Thu, 14 Oct 2010 23:24:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        Chris Frey <cdfrey@foursquare.net>, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
References: <20100928225202.GA30352@foursquare.net> <AANLkTi=ni-zEfCMXLR8BJyPQcwzEKAUKYs4uH7ur12Fk@mail.gmail.com> <4CB745FC.5090504@gmail.com>
In-Reply-To: <4CB745FC.5090504@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010142324.34822.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am Donnerstag 14 Oktober 2010, 20:03:40 schrieb Tejun Heo:
> Hello,
> 
> On 10/14/2010 04:20 PM, richard -rw- weinberger wrote:
> > It does not work for me.
> > But the error is a different one. :-)
> > Without your patch I've never got this kernel trace.
> > 
> > [   59.850000] kworker/0:1: page allocation failure. order:0, mode:0x20
> 
> Hmm... you're seeing out of memory condition.  If the code screws up
> filesystem access, I suppose it could make that happen too but can you
> please check the configuration just in case (especially the memory
> size)?  Also, if you can reliably reproduce the filesystem corruption
> w/o the patch, can you please tell me how to do it?
> 

After rerunning my test case a few times with exactly the same configuration I 
was unable to reproduce neither a filesystem corruption nor a allocation 
failure.
Your patch seems to fix the issue.

Sorry for the false negative!

BTW: This is my test case:
tar xvf linux-2.6.36-rc7.tar.bz2 && rm linux-2.6.36-rc7.tar.bz2 && tar cvf 
linux-2.6.36-rc7.tar.bz2 linux-2.6.36-rc7/ && rm -rf linux-2.6.36-rc7/
Any big tar archive will do the job...

Thanks,
//richard
