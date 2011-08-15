Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1HOXMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:12:31 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:48824 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751587Ab1HOXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:12:30 -0400
Subject: Re: [PATCH 09/11 re-post take #2] dynamic_debug: consolidate
 repetitive struct _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110815204438.GA7157@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
	 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
	 <1313089327.13877.11.camel@Joe-Laptop> <20110811205253.GC6670@redhat.com>
	 <1313131164.27549.18.camel@Joe-Laptop>  <20110815204438.GA7157@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 16:12:27 -0700
Message-ID: <1313449947.22221.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 16:44 -0400, Jason Baron wrote:
> Replace the repetitive  struct _ddebug descriptor definitions with
> a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
[]
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
[]
> +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> +	static struct _ddebug __used __aligned(8)		\
> +	__attribute__((section("__verbose"))) name = {		\
[]

Jason, just one more thing...

Because the original struct _ddebug definition
above this uses __attribute__((aligned(8))),

struct _ddebug {
	[...]
} __attribute__((aligned(8)));

( and I suppose that should be __aligned(8) instead )

the __aligned(8) use in DECLARE_DYNAMIC_DEBUG_METADATA
is not necessary.

cheers, Joe

