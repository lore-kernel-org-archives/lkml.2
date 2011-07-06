Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1GFVMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:12:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33136 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1GFVMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:12:41 -0400
Date: Wed, 6 Jul 2011 15:12:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        stable@kernel.org
Subject: Re: [PATCH] fs: fix lock initialization
Message-ID: <20110706211239.GC389@parisc-linux.org>
References: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu> <CA+55aFzeB6qtbpd_A0DaqprAyDLcETgN71eyUCkSTjwC_5Wgyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzeB6qtbpd_A0DaqprAyDLcETgN71eyUCkSTjwC_5Wgyg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:40:44AM -0700, Linus Torvalds wrote:
> Ugh. Code that depends on SLAB initializers is broken.
> 
> The reason for those initializers are traditionally "better cache
> behavior" where you don't need to initialize everything at allocation
> time, but the whole concept is almost invariably a disaster. This is a
> prime example of it.

It'd be good to have that documented somewhere.  When I wrote this code
(a decade ago), that wasn't my understanding.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
