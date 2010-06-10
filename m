Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684Ab0FJRL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:11:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45822 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613Ab0FJRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bYrXffc5xT5SvqpAfoXjQPHBrdsgvyOpBqFeTdqFJ3Nz7HebnXPt9dT1BvDRGo1B1s
         oxnQOLXLWRgd6LZkgIeX4q1Wb1j3S/GyCiyDX1f84caGH7/HVzTSGjDh4WHkrJsmm3MM
         W3dTc7VD5KyqMdxHbP6vsbDaCrBhrb5J7rU80=
Date: Thu, 10 Jun 2010 19:11:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 02/13] jump label v9: base patch
Message-ID: <20100610171123.GH5255@nowhere>
References: <cover.1276116186.git.jbaron@redhat.com> <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com> <20100609223548.GB12752@nowhere> <20100610154451.GC3923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610154451.GC3923@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 11:44:52AM -0400, Jason Baron wrote:
> On Thu, Jun 10, 2010 at 12:35:49AM +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 09, 2010 at 05:38:57PM -0400, Jason Baron wrote:
> > > +static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
> > > +{
> > > +	struct jump_entry *iter, *iter_begin;
> > > +	struct jump_label_entry *entry;
> > > +	int count;
> > > +
> > > +	sort_jump_label_entries(start, stop);
> > > +	iter = start;
> > > +	while (iter < stop) {
> > > +		entry = get_jump_label_entry((char *)iter->name);
> > > +		if (!entry) {
> > > +			iter_begin = iter;
> > > +			count = 0;
> > > +			while ((iter < stop) &&
> > > +				(strcmp((char *)iter->name,
> > > +					(char *)iter_begin->name) == 0)) {
> > > +				iter++;
> > > +				count++;
> > > +			}
> > 
> > 
> > 
> > 
> > So, you can have multiple entries with the same name? How can that happen
> > in fact?
> > 
> > 
> 
> this is the case where a single tracepoint such as kmalloc(), is used in
> all over the kernel. So, there is one name or key value associated with
> a kmalloc tracepoint. however, we have to patch the jump or nop into a
> bunch of places in the kernel text.



Ok, sounds fair then.

Thanks.

