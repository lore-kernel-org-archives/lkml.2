Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1LMJNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:13:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:60143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1LMJNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:13:19 -0500
Message-ID: <1323767540.9082.4.camel@twins>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Date: Tue, 13 Dec 2011 10:12:20 +0100
In-Reply-To: <201112122356.47545.oliver@neukum.org>
References: <20111210104341.592561407@chello.nl>
	 <201112121120.16326.oneukum@suse.de> <20111212193040.GA13131@kroah.com>
	 <201112122356.47545.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 23:56 +0100, Oliver Neukum wrote:
> I guess I worried not about the increment, but the decrement.
> Which makes me wonder what happens if you don't intend
> to get the kref again, but need to make sure it is usually freed,
> like:
> 
> CPU A                                                           CPU B
> 
> kref_get(p)
> start_io(p)
>                                                                         [interrupt from IO]
>                                                                         kref_put(p)

I would expect that if something was needed here, the io stack would
provide the barriers since the io completion will probably want to
change state set by the start_io thing.

Anyway, I would put this squarely outside the responsibility of kref.
