Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3ADJsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:48:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3ADJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:48:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130104120823.6ac07043cfdaad89d9e5b006@canb.auug.org.au>
References: <20130104120823.6ac07043cfdaad89d9e5b006@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pekey tree
Date: Fri, 04 Jan 2013 09:48:11 +0000
Message-ID: <19929.1357292891@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the pekey tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "modsign_keyring" [crypto/asymmetric_keys/pefile_key_parser.ko] undefined!

Interesting.  That first one isn't due to a missing EXPORT_SYMBOL_GPL().  That
is there.  The problem is that linux/export.h is not #included.  Why does the
C file even build, I wonder?

Anyway, the revised version is pushed.

David
