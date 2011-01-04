Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADVp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:45:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48680 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1ADVpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:45:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wL4PmbOG6nboEJFb+3xlaY/zkOmS/AafvUFDIcaDxMzjVHf9QKnQesfGSboNfVfP0H
         bxrtmW6IBTDRfTfgNpIKNX1ML3UPXoYvQA7SUSnVzu++l7msaEubzcnc6acKaTlJqIQ4
         zT+b3BB265MHXl8iBe4YpFjpXaIPyAxYql+eo=
Subject: Re: [PATCH 2/2] lib: cpu_rmap: CPU affinity reverse-mapping
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
In-Reply-To: <1294176216.3636.38.camel@bwh-desktop>
References: <1294169842.3636.31.camel@bwh-desktop>
	 <1294169967.3636.34.camel@bwh-desktop>
	 <1294175823.3420.7.camel@edumazet-laptop>
	 <1294176216.3636.38.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 22:45:48 +0100
Message-ID: <1294177548.3420.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 janvier 2011 à 21:23 +0000, Ben Hutchings a écrit :
> On Tue, 2011-01-04 at 22:17 +0100, Eric Dumazet wrote:
> > Le mardi 04 janvier 2011 à 19:39 +0000, Ben Hutchings a écrit :
> > > When initiating I/O on a multiqueue and multi-IRQ device, we may want
> > > to select a queue for which the response will be handled on the same
> > > or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add
> > > library functions to support a generic reverse-mapping from CPUs to
> > > objects with affinity and the specific case where the objects are
> > > IRQs.
> [...]
> > > +/**
> > > + * struct cpu_rmap - CPU affinity reverse-map
> > > + * @near: For each CPU, the index and distance to the nearest object,
> > > + *      based on affinity masks
> > > + * @size: Number of objects to be reverse-mapped
> > > + * @used: Number of objects added
> > > + * @obj: Array of object pointers
> > > + */
> > > +struct cpu_rmap {
> > > +	struct {
> > > +		u16     index;
> > > +		u16     dist;
> > > +	} near[NR_CPUS];
> > 
> > This [NR_CPUS] is highly suspect.
> > 
> > Are you sure you cant use a per_cpu allocation here ?
> 
> I think that would be a waste of space in shared caches, as this is
> read-mostly.

This is slow path, unless I dont understood the intent.

Cache lines dont matter. I was not concerned about speed but memory
needs.

NR_CPUS can be 4096 on some distros, that means a 32Kbyte allocation.

Really, you'll have to have very strong arguments to introduce an
[NR_CPUS] array in the kernel today.



