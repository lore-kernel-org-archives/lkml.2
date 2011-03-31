Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1CaEJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1CaEJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:09:14 -0400
Date: Thu, 31 Mar 2011 00:08:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331040818.GB1255@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <20110331033432.GA434@redhat.com>
 <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 08:44:06PM -0700, Linus Torvalds wrote:
 
 > So clearly there are shmem inodes being destroyed, but it shouldn't be
 > from an hour ago. I wonder if your system isn't as idle as you think
 > it is.

hmm. when I say idle, I mean  I'm staring at a gnome-terminal with
and ssh client, and nothing else.  Certainly nothing that should be
causing the cpu meter in the taskbar to almost max out, and definitely
nothing that should cause the fans in the laptop to be roaring.

If you want to try and repeat this experiment, this should do it..

git clone git://git.codemonkey.org.uk/trinity
cd trinity ; make
./trinity --mode=random -i

let it run for a while, then kill it.   kworker should then go nuts.

	Dave

