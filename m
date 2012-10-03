Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2JCSJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:09:12 -0400
Received: from mail.x86-64.org ([217.9.48.20]:34169 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2JCSJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:09:10 -0400
Date: Wed, 3 Oct 2012 20:08:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Blueman <daniel@numascale-asia.com>, Ingo Molnar <mingo@redhat.com>,
        Steffen Persvold <sp@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>, x86@kernel.org
Subject: Re: [PATCH] RFC: Fix AMD Northbridge-ID contiguity assumptions
Message-ID: <20121003180859.GB15939@aftab.osrc.amd.com>
References: <1349256029-14851-1-git-send-email-daniel@numascale-asia.com>
 <506C56B2.50505@zytor.com>
 <CAP-4_fVhkjb=0YdYz37PEg3Or-hbRO8F40tHqEsRCC-pYY_HOg@mail.gmail.com>
 <506C5EDB.9000107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C5EDB.9000107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 08:50:51AM -0700, H. Peter Anvin wrote:
> On 10/03/2012 08:30 AM, Daniel Blueman wrote:
> > >
> > > Is that "on NumaScale systems"?  If so, please say so rather than trying
> > > to make it sound generic; if it is not, can you give some other examples?
> >
> >It is for Numascale (NumaChip) systems for our purposes.
> >
> >Any other systems which interconnect Opterons via address space routing
> >(needed for >8 HT nodes) will get this benefit. I can't put my hand to
> >exactly what is out there, but can find out.
> >
> 
> The reason I'm asking is because it is an important bit of the
> record of the code to know if this is a specific need or a general
> need.  This may be obvious now, but 5-10 years from now someone will
> need to know why or what.
> 
> The two paragraphs above is exactly what is needed, i.e. "NumaChip
> or any other design which shares these specific design features:
> ..."

Absolutely!

And it would be best to put that explanation in the code somewhere
around node_to_amd_index() so that it is there at a first glance.

Btw, I'll review the patch tomorrow since it is a holiday today here.

I have only two nits for now:

* node is u32, do you really have such big systems with 2^32-1 nodes? Or
can the max node number fit into a, say, u16 or u8?

* node_to_amd_index returns 0 in the unsuccessful case but node index 0
seems ok to me, i.e. the first element in the array of northbridges. It
probably should return a negative value rather to signal a failure...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
