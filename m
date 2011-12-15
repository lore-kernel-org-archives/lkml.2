Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab1LOECq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 23:02:46 -0500
Received: from ozlabs.org ([203.10.76.45]:42978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab1LOECp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 23:02:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 1/2] params: <level>_initcall-like kernel parameters
In-Reply-To: <1323712627-17353-1-git-send-email-pawel.moll@arm.com>
References: <1323712401.2391.93.camel@hornet.cambridge.arm.com> <1323712627-17353-1-git-send-email-pawel.moll@arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 14:21:00 +1030
Message-ID: <871us6sdaz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 17:57:06 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> This patch adds a set of macros that can be used to declare
> kernel parameters to be parsed _before_ initcalls at a chosen
> level are executed. Such parameters are marked using existing
> "flags" field of the "kernel_param" structure.
> 
> Linker macro collating init calls had to be modified in order
> to add additional symbols between levels that are later used
> by the init code to split the calls into blocks.

This patch wasn't quite what I was thinking, but I've realized that
we can't put the params in the .init section, your approach is probably
the best one.

Note that I've just created a series which gets rid of that silly ISBOOL
thing, so you can use the whole field for "level".  Then I set the level
to -1 for the normal calls; I want to use -2 for the early calls, but
that's not done yet...

I'll rework and rebase your patch like that now.

Thanks!
Rusty.
