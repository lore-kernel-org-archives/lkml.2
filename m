Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1LMJs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:48:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1LMJsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:48:25 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Date: Tue, 13 Dec 2011 10:49:52 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
References: <20111210104341.592561407@chello.nl> <201112122356.47545.oliver@neukum.org> <1323767540.9082.4.camel@twins>
In-Reply-To: <1323767540.9082.4.camel@twins>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112131049.53008.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. Dezember 2011, 10:12:20 schrieb Peter Zijlstra:
> On Mon, 2011-12-12 at 23:56 +0100, Oliver Neukum wrote:
> > I guess I worried not about the increment, but the decrement.
> > Which makes me wonder what happens if you don't intend
> > to get the kref again, but need to make sure it is usually freed,
> > like:
> > 
> > CPU A                                                           CPU B
> > 
> > kref_get(p)
> > start_io(p)
> >                                                                         [interrupt from IO]
> >                                                                         kref_put(p)
> 
> I would expect that if something was needed here, the io stack would
> provide the barriers since the io completion will probably want to
> change state set by the start_io thing.

> Anyway, I would put this squarely outside the responsibility of kref.

I agree, so let's remove it.

	Regards
		
