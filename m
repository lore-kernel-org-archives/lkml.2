Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0LOCWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:22:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40889 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0LOCWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:22:47 -0500
Date: Wed, 15 Dec 2010 07:52:35 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 4/21] Make fill_psinfo generic
Message-ID: <20101215075235.5e3f36b1@suzukikp>
In-Reply-To: <AANLkTimA635P-X5SVaBwY9exfODSgzhDWCJebSRcbLO=@mail.gmail.com>
References: <20101214152259.67896960@suzukikp>
	<20101214153135.5f4423e0@suzukikp>
	<AANLkTimA635P-X5SVaBwY9exfODSgzhDWCJebSRcbLO=@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 07:55:00 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 14, 2010 at 2:01 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
> > +       /*
> > +        * If we are dumping core for "another task"
> > +        * we can't use copy_from_user().
> > +        */
> > +       if (p->group_leader == current->group_leader) {
> 
> This is totally bogus. "group_leader" has absolutely nothing to do
> with whether the process shares the address space. It's about signal
> sharing etc.
> 
> The way to check whether they share the same address space is to check
> whether "mm" is the same.
> 

OK. I will make use of the mm here.

Thanks
Suzuki


