Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1KGMfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:35:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57061 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1KGMfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:35:52 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
Date: Mon, 07 Nov 2011 13:34:39 +0100
In-Reply-To: <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320669279.18053.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 17:26 +0800, Yong Zhang wrote:
> Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
> lockdep_init_map() will clear all the struct. But it will break
> lock_set_class()/lock_set_subclass(). A typical race condition
> is like below:

This is a horridly ugly patch, why not simply revert that memset commit?
I really can't see the point of that, and keeping the name/key pointers
around (which can only be over-written with the same values, right?)
would also cure the problem.

Sadly the changelog is completely devoid of useful information (which is
my own damn fault, I should never have accepted the patch in that form),
so I can't actually comment on what it was supposed to fix.

Arguably kmemcheck is on crack or so since both name and key pointers
should be in .data so there cannot be a leak by copying the thing over.
