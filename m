Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2BVKTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:19:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2BVKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:19:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
References: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
To: Bobby Powers <bobbypowers@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH tip/x86/x32] fs: fix close_on_exec pointer in alloc_fdtable
Date: Wed, 22 Feb 2012 10:18:56 +0000
Message-ID: <1986.1329905936@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bobby Powers <bobbypowers@gmail.com> wrote:

> alloc_fdtable allocates space for the open_fds and close_on_exec
> bitfields together, as 2 * nr / BITS_PER_BYTE.  close_on_exec needs to
> point to open_fds + nr / BITS_PER_BYTE, not open_fds + nr /
> BITS_PER_LONG, as introducted in 1fd36adc: Replace the fd_sets in
> struct fdtable with an array of unsigned longs.
> 
> Signed-off-by: Bobby Powers <bobbypowers@gmail.com>

Yes, you're right.  At one point I changed data to be an unsigned long *.

Acked-by: David Howells <dhowells@redhat.com>
