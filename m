Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2IRSxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab2IRSxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:53:22 -0400
Date: Tue, 18 Sep 2012 14:53:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120918185310.GA27689@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Suzuki Poulose <suzuki@in.ibm.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:38:44AM -0700, Linus Torvalds wrote:
 > Quoting the entire email, since I added Greg to the list of people (as
 > the documented maintainer of debugfs) along with what I think are the
 > guilty parties.
 > 
 > Dave, is trinity perhaps doing read calls on the same file in parallel?

Yeah, entirely possible. It opens hundreds of fd's on startup, and then
a bunch of threads do whatever operations are specified on those fds.
(in this case, just read/setsockopt, but probably the read's are all that
 is needed to trigger this)

	Dave

