Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2HTFCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:02:00 -0400
Received: from ozlabs.org ([203.10.76.45]:34526 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab2HTFBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:01:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 1/7] integrity: added digest calculation function
In-Reply-To: <f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com> <f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 20 Aug 2012 12:29:33 +0930
Message-ID: <87628e5kve.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012 21:43:06 +0300, Dmitry Kasatkin <dmitry.kasatkin@intel.com> wrote:
> +	} else {
> +		struct {
> +			struct shash_desc shash;
> +			char ctx[crypto_shash_descsize(tfm)];
> +		} desc;

Linus had a rant a while ago about using variable-sized stack vars in
the kernel (can't find a reference right now, sorry).

The problem is that either you know there's a limit to
crypto_shash_descsize(), in which case you can just use this here, or
you don't know, in which case, this risks a stack oveflow.

Cheers,
Rusty.
