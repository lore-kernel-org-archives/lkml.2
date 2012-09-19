Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2ISVod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:44:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2ISVoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:44:32 -0400
Date: Wed, 19 Sep 2012 17:41:12 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120919214112.GA15027@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Suzuki Poulose <suzuki@in.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918185310.GA27689@redhat.com>
 <5059D015.2020104@linux.vnet.ibm.com>
 <CA+55aFwuO_8Wy6C7rALajiK2Pro84BrfzmKHpARx4EfG8qNMhw@mail.gmail.com>
 <alpine.DEB.2.00.1209191340410.6273@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209191340410.6273@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:27:37PM -0700, David Rientjes wrote:
 > On Wed, 19 Sep 2012, Linus Torvalds wrote:
 > 
 > > > Create a 350 processes reading /sys/kernel/debug/kvm/spinlocks/histo_blocked
 > > > file simultaneously in while loop for more than 3 hours on my box.
 > > 
 > > You need to open the file a single time, and then after that sinelg
 > > open (either threaded or with fork()) do multiple concurrent copies
 > > something like
 > > 
 > >    for (;;) {
 > >       char buf[1024];
 > >       lseek(fd, 0, SEEK_SET);
 > 
 > These are non-seekable files, so this will always fail.  That makes the 
 > race much more difficult to trigger: the read needs to call 
 > u32_array_read() with both threads finding *ppos == 0 and then race 
 > between the kfree() and resetting of file->private_data pointer.
 > 
 >  [ I'm surprised that Dave was able to trigger this so often that he has 
 >    800MB of log. ]

Brainfart. 800Kb. Still, lots.

	Dave

