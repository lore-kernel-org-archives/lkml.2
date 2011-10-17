Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1JQPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:00:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37094 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1JQPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:00:04 -0400
Date: Mon, 17 Oct 2011 15:59:52 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-ID: <20111017145952.GB15769@srcf.ucam.org>
References: <20111017032232.GA4816@srcf.ucam.org>
 <4E9BBB6D.4050004@linux.intel.com>
 <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
 <20111017124647.GA12838@srcf.ucam.org>
 <1318856786.4172.22.camel@twins>
 <20111017141147.GA14581@srcf.ucam.org>
 <1318861707.4172.32.camel@twins>
 <20111017144013.GA15447@srcf.ucam.org>
 <1318862969.4172.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318862969.4172.45.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 04:49:29PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 15:40 +0100, Matthew Garrett wrote:
> > On Mon, Oct 17, 2011 at 04:28:27PM +0200, Peter Zijlstra wrote:
> > > An XDamage and repaint from the X client, after which your copy will
> > > complete and you get what you asked for?
> > 
> > An XDamage and then an asynchronous RPC call to the remote server to 
> > identify the contents of the next frame before drawing them, plus some 
> > sort of new synchronisation mechanism for blocking the X query until 
> > that point?
> 
> Why would this be a problem? 
> 
> I mean, why would getting a copy of an otherwise invisible surface be a
> performance sensitive path? If the compositor needs the surface it would
> make it visible and send the XDamage once and keep it visible henceforth
> until the time it again becomes invisible, at which point you have to
> stop updates again.

I'm not saying that it's a problem. I'm saying that your approach 
changes behavioural semantics in a way that may violate application 
expectations just as surely as changing the timer behaviour does. 
There's no free approach.

> > Timers are a resource. People want to manage that resource. cgroups are 
> > a convenient mechanism for managing resources.
> 
> Yes, and a ball is round (unless you're a USA-ian, in which case they're
> ovoid), what's your point?

If there's no reason to want to manage that resource, why do we support 
timer slack at all?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
