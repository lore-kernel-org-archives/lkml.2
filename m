Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2APSfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:35:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab2APSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:35:15 -0500
Date: Mon, 16 Jan 2012 10:34:38 -0800
From: Greg KH <gregkh@suse.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
Message-ID: <20120116183438.GA14792@suse.de>
References: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com>
 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com>
 <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
 <20120114144938.GA32033@suse.de>
 <20120116181135.GA2680@suse.de>
 <3908561D78D1C84285E8C5FCA982C28F01C672@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F01C672@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 06:27:16PM +0000, Luck, Tony wrote:
> > The "correct" way to fix this up would be to have a per-cpu structure
> > for all of the different mce things that are created in this driver
> > (struct device, struct mce, exception counts, work queues, polling
> > banks, etc.), but that seems pretty messy, and I imagine some of these
> > want to stay as-is for some performance issues.  As I don't know this
> > code at all, I'm a bit leary to make that kind of change.
> 
> If you get so many machine checks that you care about the performance
> of the handler - you may be worrying about the wrong things.
> 
> I'm more concerned about maintainability of the code. Seto-san has
> submitted many patches re-grouping the functions inside mce.c into
> functional areas - keeping the data structures separated makes
> sense - especially if there is some goal of splitting mce.c into
> separate files.

Ok, I'll leave that alone, and just focus on the struct device stuff, as
that I know can't be performance critical :)

thanks,

greg k-h
