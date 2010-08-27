Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0H0WMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:12:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0H0WMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:12:49 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Sat, 28 Aug 2010 00:13:18 +0200
User-Agent: KMail/1.9.10
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
References: <201008271537.35709.ptesarik@suse.cz> <201008272303.34228.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008280013.19941.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 of August 2010 23:11:55 Luck, Tony wrote:
> > One more idea. The wrap-around case is the only one when the high word is
> > modified. This is in fact the only case when the fetchadd.acq competes
> > with the st2.rel about the actual contents of that location. I don't know
> > if it matters...
>
> I pondered that for a while - but I have difficulty believing that
> fetchadd looks at which bits changed and only writes back the bytes
> that did.

OTOH the counter is only 15-bit, so it also wraps around at 0xfffe7fff, but
I have never seen it fail there. It always fails after the wrap-around from 
0xfffeffff.

Petr Tesarik
