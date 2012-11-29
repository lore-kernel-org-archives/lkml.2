Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2K2S74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:59:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2K2S7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:59:55 -0500
Date: Thu, 29 Nov 2012 19:59:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129185953.GW16230@one.firstfloor.org>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com> <1354121029-1376-23-git-send-email-koverstreet@google.com> <m28v9kgsen.fsf@firstfloor.org> <20121129185720.GE15094@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129185720.GE15094@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:57:20AM -0800, Kent Overstreet wrote:
> On Thu, Nov 29, 2012 at 10:45:04AM -0800, Andi Kleen wrote:
> > Kent Overstreet <koverstreet@google.com> writes:
> > 
> > > This implements a refcount with similar semantics to
> > > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > > but dynamically switches to per cpu refcounting when the rate of
> > > gets/puts becomes too high.
> > 
> > This will only work if you put on the same CPU as you get, right?
> 
> Nope, no such restriction.

I don't see how you ensure you're doing the __this_cpu_dec on the same
CPU as you did the get

-Andi
