Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1IUVNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:13:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:60608 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1IUVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:13:05 -0400
Date: Wed, 21 Sep 2011 17:12:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH] xen/pciback: Use mutexes when working
 with Xenbus state transitions.
Message-ID: <20110921211259.GB30029@phenom.oracle.com>
References: <20110916190601.GA31796@phenom.oracle.com>
 <4E7738E90200007800056A54@nat28.tlf.novell.com>
 <4E773D440200007800056A6D@nat28.tlf.novell.com>
 <20110921210838.GA1016@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921210838.GA1016@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020B.4E7A535D.009E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:08:38PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 19, 2011 at 12:01:56PM +0100, Jan Beulich wrote:
> > >>> On 19.09.11 at 12:43, "Jan Beulich" <JBeulich@suse.com> wrote:
> > >>>> On 16.09.11 at 21:06, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > 
> > >> The caller that orchestrates the state changes is xenwatch_thread
> > >> and it takes a mutex. In our processing of Xenbus states we can take
> > >> the luxery of going to sleep on a mutex, so lets do that and
> > > 
> > > This is only the direct conversion of existing spinlock accesses in
> > > xenbus.c. However, in the course of converting from the legacy
> > > implementation you stripped a couple more (in xen_pcibk_attach(),
> > > xen_pcibk_reconfigure(), and xen_pcibk_setup_backend()), and
> > 
> > Actually, xen_pcibk_attach() has its lock taken in xen_pcibk_do_attach(),
> > so no change needed there.
> > 
> > In xen_pcibk_reconfigure() and xen_pcibk_setup_backend() the locking
> > may be redundant with the one in passthrough.c/vpci.c - is that the
> > basis upon which you removed the locks taken there?
> 
> No. I believe the reason was much simpler.. it was b/c of this patch (see below).
> But for the life of me I don't recall what deadlock we could hit.

You know what.. I think the issue was that I was trying to fix the
"sleeping on a spinlock" issue and was moving the spinlocks around to fix it.

.. Without realizing I could have just used a mutex.
