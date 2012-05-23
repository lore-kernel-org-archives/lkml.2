Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2EWMyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:54:24 -0400
Received: from ozlabs.org ([203.10.76.45]:39248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2EWMyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:54:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 23 May 2012 22:21:28 +0930
Message-ID: <87obpfxdpr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012 00:02:19 +0100, David Howells <dhowells@redhat.com> wrote:
> The extended module file format is as follows:
> 
>   The module signature is appended to the end of the module file, followed by
>   "@mod_size@\n@sig_size@\nThis Is A Crypto Signed Module".
> 
>   The EOF must follow the magic string directly, so nothing further must be
>   appended to the file.
>
>   mod_size and sig_size are left-aligned decimal numbers, space-padded to 8
>   characters.  mod_size is the size of the module payload part of the file and
>   sig_size is the size of the signature blob.

Hi David,

        That's pretty weird.  Why not put the "@This Is A Crypto Signed
Module\n" before the signature?  Then module-size is implied: everything
before that signature.  The signature size is implied: everything after
that signature.

        In fact, I'd modify this slightly, to allow multiple signatures.
This would work nicely with a deterministic strip.  Find the signatures
backward, and truncate as they fail.

        If you want to be super-paranoid, scan for that signature before
signing the module.

Cheers,
Rusty.
