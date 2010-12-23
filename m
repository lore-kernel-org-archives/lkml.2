Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0LWTKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 14:10:42 -0500
Received: from jcz.nl ([213.196.18.5]:33326 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab0LWTKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:10:41 -0500
Message-ID: <4D139EAE.9090307@jcz.nl>
Date: Thu, 23 Dec 2010 20:10:38 +0100
From: Jaap Crezee <jaap@jcz.nl>
Organization: JCZ-Automatisering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com> <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com> <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com> <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com>
In-Reply-To: <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/10 19:51, Greg Freemyer wrote:
 > On Thu, Dec 23, 2010 at 12:47 PM, Jeff Moyer<jmoyer@redhat.com>  wrote:
 > I suspect a mailserver on a raid 5 with large chunksize could be a lot
 > worse than 2x slower.  But most of the blame is just raid 5.

Hmmm, well if this really is so.. I use raid 5 to not "spoil" the storage space 
of one disk. I am using some other servers with raid 5 md's which seems to be 
running just fine; even under higher load than the machine we are talking about.

Looking at the vmstat block io the typical load (both write and read) seems to 
be less than 20 blocks per second. Will this drop the performance of the array 
(measured by dd if=/dev/md<x> of=/dev/null bs=1M) below 3MB/secs?

 > ie.
 > write 4K from userspace
 >
 > Kernel
 > Read old primary data, wait for data to actually arrive
 > Read old parity data, wait again
 > modify both for new data
 > write primary data to drive queue
 > write parity data to drive queue

What if I (theoratically) change the chunksize to 4kb? (I can try that in the 
new server...).

Jaap
