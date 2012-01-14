Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2ANOuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 09:50:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2ANOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 09:50:38 -0500
Date: Sat, 14 Jan 2012 06:49:38 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
Message-ID: <20120114144938.GA32033@suse.de>
References: <20120111000051.GA28874@dztty>
 <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com>
 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com>
 <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 06:53:04PM -0800, Linus Torvalds wrote:
> On Fri, Jan 13, 2012 at 6:41 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >
> > YES!! Finally I have a fix for this whole MCE thing! :-)
> 
> Goodie.
> 
> > The patch below works perfectly for me - I tested multiple CPU hotplug
> > operations as well as multiple pm_test runs at core level. Please let me
> > know if this solves the suspend issue as well..
> 
> Ok, I'll try, and I bet it does.
> 
> HOWEVER.
> 
> I'd be a whole lot happier knowing exactly which field in "struct
> device" that needed to be NULL before it gets registered.
> 
> I don't like how
> 
>   device_register() + device_create_file(dev)..
> 
> is not sufficiently undone by
> 
>  .. device_remove_file(dev) +  device_unregister()
> 
> so that it can't be repeated. Exactly *what* state is stale and
> re-used incorrectly if you do that device_register() a second time.
> 
> It smells like a misfeature of the device core handling.

It has to do with the fact that this is a "static" device that is being
reused.  Normally it would be cleaned up properly in the release
function, but as there isn't one, some fields are being left in a bad
state.

I'll look into this Sunday better when I have the chance, I'm currently
on the road until late tonight, skiing, and it's hard to write patches
from a chair lift...

thanks,

greg k-h
