Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0H0VDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0H0VDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:03:02 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Fri, 27 Aug 2010 23:03:32 +0200
User-Agent: KMail/1.9.10
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
References: <201008271537.35709.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com> <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008272303.34228.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 of August 2010 22:29:41 Luck, Tony wrote:
> > If this is a memory ordering problem (and that seems quite plausible)
> > then a liberal sprinkling of "ia64_mf()" calls throughout the spinlock
> > routines would probably make it go away.
>
> I think I take this back ... if it were a memory ordering problem, then
> it could show up any time - not just at wrap-around.

One more idea. The wrap-around case is the only one when the high word is 
modified. This is in fact the only case when the fetchadd.acq competes with 
the st2.rel about the actual contents of that location. I don't know if it 
matters...

Petr Tesarik
