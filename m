Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0I1Mve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:51:34 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56439 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab0I1Mvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:51:33 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 08:51:33 EDT
Message-Id: <1285677740.30176.1397281937@webmail.messagingengine.com>
X-Sasl-Enc: pgnhCy02QI/paiGJe7LaIDIyUiep/fc/2CCY4THDhL6n 1285677740
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Christoph Lameter" <cl@linux.com>, "Robert Mueller" <robm@fastmail.fm>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Mel Gorman" <mel@csn.ul.ie>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm" <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <alpine.DEB.2.00.1009280727370.4144@router.home>
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem>
 <20100921090407.GA11439@csn.ul.ie>
 <20100927110049.6B31.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1009270828510.7000@router.home>
 <1285629420.10278.1397188599@webmail.messagingengine.com>
 <alpine.DEB.2.00.1009280727370.4144@router.home>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad
 forfile/email/web servers
Date: Tue, 28 Sep 2010 22:42:20 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 07:35 -0500, "Christoph Lameter" <cl@linux.com> wrote:
> > The problem we saw was purely with file caching. The application wasn't
> > actually allocating much memory itself, but it was reading lots of files
> > from disk (via mmap'ed memory mostly), and as most people would, we
> > expected that data would be cached in memory to reduce future reads from
> > disk. That was not happening.
> 
> Obviously and you have stated that numerous times. Problem that the use
> of
> a remote memory will reduced performance of reads so the OS (with
> zone_reclaim=1) defaults to the use of local memory and favors reclaim of
> local memory over the allocation from the remote node. This is fine if
> you have multiple applications running on both nodes because then each
> application will get memory local to it and therefore run faster. That
> does not work with a single app that only allocates from one node.

Is this what's happening, or is IO actually coming from disk in preference
to the remote node?  I can certainly see the logic behind preferring to
reclaim the local node if that's all that's happening - though the OS should
be allocating the different tasks more evenly across the nodes in that case.

> Control over memory allocations over the various nodes under NUMA
> for a process can occur via the numactl ctl or the libnuma C apis.
> 
> F.e.e
> 
> numactl --interleave ... command
> 
> will address that issue for a specific command that needs to go

Gosh what a pain.  While it won't kill us too much to add to our
startup, it does feel a lot like the tail is wagging the dog from here
still.  A task that doesn't ask for anything special should get sane
defaults, and the cost of data from the other node should be a lot
less than the cost of the same data from spinning rust.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

