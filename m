Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2HSPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:25:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58390 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2HSPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:25:56 -0400
Date: Sun, 19 Aug 2012 17:25:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 53/74] x86, lto, paravirt: Make paravirt thunks global
Message-ID: <20120819152554.GW11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-54-git-send-email-andi@firstfloor.org> <5030A354.7000109@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030A354.7000109@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 01:27:00AM -0700, Jeremy Fitzhardinge wrote:
> On 08/18/2012 07:56 PM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > The paravirt thunks use a hack of using a static reference to a static
> > function to reference that function from the top level statement.
> >
> > This assumes that gcc always generates static function names in a specific
> > format, which is not necessarily true.
> >
> > Simply make these functions global and asmlinkage. This way the
> > static __used variables are not needed and everything works.
> 
> I'm not a huge fan of unstaticing all this stuff, but it doesn't
> surprise me that the current code is brittle in the face of gcc changes.

Hmm actually reading my own patch again it may be wrong. You need
regparm(3) here right? asmlinkage forces it to (0). I'll change it to 
__visible. I think I did that earlier for all the 32bit code, but missed
this one.

-Andi
