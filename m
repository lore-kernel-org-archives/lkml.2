Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0K3KHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:07:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33750 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0K3KHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:07:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PYA6grH4tRk3hBNRGsZZa8neew/T1K1MZGg410CbeY4NskOM9Xej2hKHCTPWTrytev
         cUzKeNJvP3vRCtkTHVf4ist8bt/RN2FeE5dSYapSM7WVFddQ+kZ6TrgKw/CDodTbA13u
         ggJUwzZ8jpTsRt2FKyrP+6Fb3ZT+Sf5aVxNAs=
Date: Tue, 30 Nov 2010 12:07:42 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: fix incorrect proc spurious output
Message-ID: <20101130100742.GA4856@core2.telecom.by>
References: <4CF4B778.90604@jp.fujitsu.com>
 <AANLkTinSYu9JhqY8NAH+sNAKuO9cUZwJTxK46_8nx3Qh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinSYu9JhqY8NAH+sNAKuO9cUZwJTxK46_8nx3Qh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:08:13PM +0800, Yong Zhang wrote:
> 2010/11/30 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > Fix the problem that all the /proc/irq/XX/spurious files shows the IRQ
> > 0 information.
> >
> > Current irq_spurious_proc_open() passes on NULL as the 3rd argument,
> > which is used as an IRQ number in irq_spurious_proc_show(), to the
> > single_open(). Because of this, all the /proc/irq/XX/spurious file
> > shows IRQ 0 information regardless of the IRQ number.
> >
> > To fix the problem, irq_spurious_proc_open() must pass on the
> > appropreate data (IRQ number) to single_open().
> >
> > Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> Looks good.
> 
> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
> 
> BTW, it's introduced by a1afb6371bb5341057056194d1168753f6d77242
> So should we Cc'ing stable?

Definitely.

> >  static int irq_spurious_proc_open(struct inode *inode, struct file *file)
> >  {
> > -       return single_open(file, irq_spurious_proc_show, NULL);
> > +       return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
> >  }
