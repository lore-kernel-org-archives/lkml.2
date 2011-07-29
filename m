Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1G2XtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:49:08 -0400
Received: from fieldses.org ([174.143.236.118]:34780 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1G2XtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:49:06 -0400
Date: Fri, 29 Jul 2011 19:48:57 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Banks <gnb@fastmail.fm>, Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] sunrpc: use better NUMA affinities
Message-ID: <20110729234857.GA30941@fieldses.org>
References: <1311921035.7845.10.camel@edumazet-laptop>
 <4E3258E1.6020000@fastmail.fm>
 <20110729103634.GA12050@infradead.org>
 <5933F48C-49D6-492D-AB7B-B76A3ADDB6C6@fastmail.fm>
 <1311941491.2843.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <F67B6E82-9FA8-464E-B3FB-DC0D4EC18BB0@fastmail.fm>
 <20110729164836.GL23194@fieldses.org>
 <20110729165345.GM23194@fieldses.org>
 <F562C6F4-3FC2-4952-A903-8E87E9EF2D9D@fastmail.fm>
 <20110730093025.716f3f50@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110730093025.716f3f50@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 09:30:25AM +1000, NeilBrown wrote:
> On Sat, 30 Jul 2011 06:34:44 +1000 Greg Banks <gnb@fastmail.fm> wrote:
> 
> > 
> > 
> > Sent from my iPhone
> > 
> > On 30/07/2011, at 2:53, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > 
> > > On Fri, Jul 29, 2011 at 12:48:36PM -0400, bfields wrote:
> > >> On Fri, Jul 29, 2011 at 11:30:05PM +1000, Greg Banks wrote:
> > >>>
> > >>>
> > >>> Sent from my iPhone
> > >>>
> > >>> On 29/07/2011, at 22:11, Eric Dumazet <eric.dumazet@gmail.com>  
> > >>> wrote:
> > >>>
> > >>>> Le vendredi 29 juillet 2011 à 21:58 +1000, Greg Banks a écrit :
> > >>>>
> > >>>>>
> > >>>>> Sure, and a whole lot of the callsites are ("..._%d", cpu),  
> > >>>>> hence the
> > >>>>> unfortune :(
> > >>>>
> > >>>> BTW, we could name nfsd threads differently :
> > >>>>
> > >>>> Currently, they all are named : "nfsd"
> > >>>>
> > >>>> If SVC_POOL_PERCPU is selected, we could name them :
> > >>>> nfsd_c0 -> nfsd_cN
> > >>>>
> > >>>> If SVC_POOL_PERNODE is selected, we could name them :
> > >>>> nfsd_n0  -> nfsd_nN
> > >>>>
> > >>>> That would help to check with "ps aux" which cpu/nodes are under
> > >>>> stress.
> > >>>>
> > >>>>
> > >>>
> > >>> I like it!
> > >>
> > >> Yup, patch welcomed.--b.
> > >
> > > (Annoying fact: some initscripts stop nfsd using a rough equivalent of
> > > "killall nfsd".  So the name of the threads is arguably ABI.  I think
> > > those initscripts are nuts and deserve what they get, but that may be
> > > because I'm forgetting the reason they do that.)
> > >
> > 
> > We had this discussion in May-June 2008; it's because the nfsds were  
> > once  many many years ago userspace threads.
> 
> Even when they became kernel threads, 'kill' was the only way to kill them -
> at first.
> 
> > 
> > The "killall nfsd" semantics in those scripts are awful and lead to  
> > problems shutting down when there are lots of threads. It would  
> > probably be an improvement to provide a better shutdown mechanism and  
> > force distros to use it.
> 
> rpc.nfsd 0
> 
> will stop all nfsd threads.  Follow with
> 
>   exportfs -f
> 
> and you should be done.  I'm not 100% sure about the nfsv4 thread though -
> would need to check.

Should be fine.

--b.
