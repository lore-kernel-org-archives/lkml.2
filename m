Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1CBQTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:19:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52148 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1CBQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bW0iw4JqgSnS5eYXknc+6MprCHGTwY547Rt38YcHcTMOoDBljFBuFgoJ9F6WDr4KFQ
         156TwQ5ozS8XxAJ+pJfC9HB+qrUKN1M7WFmhR7iDM5Li1GbVn7JESgsBL//Kgx5/0fI1
         8vlU2TgXKfsL8VdoMzfDesNbHqxRrSHZ+0OVg=
Date: Wed, 2 Mar 2011 17:19:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302161900.GP3319@htj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Tue, Mar 01, 2011 at 02:41:55PM -0800, Yinghai Lu wrote:
> > 2. find_early_table_space() always calculates the amount of the needed
> >   space from 0 to the specified @end.  As nodes are registered, each
> >   node would try to allocate accumulative amount of space for page
> >   table.  This probably wouldn't cause any actual problem (may affect
> >   emulated configurations a bit tho).
> 
> interesting.

Yeah, it's a pretty interesting piece of code in need of some cleanup.

I'm reverting the NUMA-affine page table allocation for now.  I wish
something like the following happens during the next devel cycle.

* General cleanup of page table allocation code.  I'm not talking
  about major rewrite or anything major.  Just making the code sane(r)
  so that they take parameters instead of doing subtle stuff with
  internal #ifdef's.  And hopefully proper documentation.

* Redo the NUMA-affine page table allocation in simpler way using
  cleaned up allocation functions.  As suggested before, IMO, just
  taking top and bottom of nodes is enough.  Again, hopefully, with
  enough documentation on both what and why.

If you're interested in doing the above, please go ahead and let me
know.

Thank you.

-- 
tejun
