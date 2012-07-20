Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2GTVGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:06:17 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:57101 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2GTVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:06:15 -0400
Date: Fri, 20 Jul 2012 18:06:06 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: nicolas prochazka <prochazka.nicolas@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oops in kernel ( 3.4.x -> 3.5rc )
Message-ID: <20120720210606.GC15677@oc1711230544.ibm.com>
References: <CADdae-i2FWspdm_BPQAeO3HUUyOWj8rDui0cTGR6fkRv7yr2zw@mail.gmail.com>
 <20120720132153.GA26110@redhat.com>
 <20120720202155.GB15677@oc1711230544.ibm.com>
 <CADdae-hyq7RALEg6fOTQZc_cDoi8PnovBZ2xNdsZRNTqfJnORA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADdae-hyq7RALEg6fOTQZc_cDoi8PnovBZ2xNdsZRNTqfJnORA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072021-9254-0000-0000-000009AB5DF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:52:40PM +0200, nicolas prochazka wrote:
> Hello
> the problem is occured with  :
> - linux kernel 3.4.5    i do not test with 3.4.0 / 1 / 2 / 3 / 4    ,
> but i can if you want
> - linux kernel 3.5rc6 rc7  / do not test with other rc.
> 
> the problem is not occured with :
> linux kernel 3.3.4 / 3.3.8
> 
> These servers are used for :
> - starting a lot of virtual machine with qemu-kvm ( ~ 40 )   ( lot of
> select i think)
> - do a lot of network tests with openvswitch
> 
> I can test a kernel 3.4.x before and after a commit id (?) to find a regression.
> 
> Regards,
> Nicolas.
> 

Can you try this commit 1fd36adcd98c14d2fd97f545293c488775cb2823? And
the commit before it?

> 
> 2012/7/20 Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>:
> > On Fri, Jul 20, 2012 at 09:21:53AM -0400, Dave Jones wrote:
> >> On Fri, Jul 20, 2012 at 11:56:06AM +0200, nicolas prochazka wrote:
> >>
> >>  > [ 2384.900061] BUG: unable to handle kernel paging request at 000000010000002f
> >>
> >> That '1' looks like a random bit flip. Try running memtest86.
> >>
> >
> > Looks more a 32-bit value of 1 followed by a 32-bit value of 0x2f. Most
> > likely a pointer to some other piece of a struct. However, taking a look
> > at fs/files.c code, nothing seems suspicious.
> >
> > Nicolas, it wasn't clear to me if you had problems with 3.4 too. There
> > has been some changes in fs/files.c on 3.4-rc1 in the piece of code
> > where you hit the problem.
> >
> > What does your system exercise? Any chance you are using a lot of
> > select, which has also been changed in those same patches to fs/files.c?
> >
> > Regards.
> > Cascardo.
> >
> >
> >>  > [ 2384.910010] Pid: 23838, comm: queue.sh Tainted: G      D W
> >>
> >> This wasn't the first problem either.
> >>
> >>  > [ 2397.885344] BUG: unable to handle kernel paging request at 000000010000003b
> >>
> >> Looks like the same flipped bit.
> >>
> >>       Dave
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> 

