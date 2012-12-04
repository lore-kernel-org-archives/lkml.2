Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2LEBru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:47:50 -0500
Received: from ozlabs.org ([203.10.76.45]:53077 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab2LEBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:47:43 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Michal Marek <mmarek@suse.cz>, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MODSIGN: Fix comparison erros in scripts/sign-file
In-Reply-To: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
References: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Dec 2012 10:14:39 +1030
Message-ID: <87k3sxgz6g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:

> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/sign-file |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/sign-file b/scripts/sign-file
> index 87ca59d..974a20b 100755
> --- a/scripts/sign-file
> +++ b/scripts/sign-file
> @@ -156,12 +156,12 @@ sub asn1_extract($$@)
>  
>  	if ($l == 0x1) {
>  	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1));
> -	} elsif ($l = 0x2) {
> +	} elsif ($l == 0x2) {
>  	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0], 2));
> -	} elsif ($l = 0x3) {
> +	} elsif ($l == 0x3) {
>  	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1)) << 16;
>  	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0] + 1, 2));
> -	} elsif ($l = 0x4) {
> +	} elsif ($l == 0x4) {
>  	    $len = unpack("N", substr(${$cursor->[2]}, $cursor->[0], 4));
>  	} else {
>  	    die $x509, ": ", $cursor->[0], ": ASN.1 element too long (", $l, ")\n";

This was already applied to Linus' tree as 

commit 916492b1e1a186260951831c53a53d8a448dc026
Author: Chun-Yi Lee <jlee@suse.com>
Date:   Wed Nov 21 11:26:09 2012 +0000

Thanks,
Rusty.
