Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab2LIRxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:53:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab2LIRxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:53:16 -0500
Date: Sun, 9 Dec 2012 18:53:15 +0100
From: Michal Marek <mmarek@suse.cz>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scripts/tags.sh: Support compiled source
Message-ID: <20121209175315.GD29331@pobox.suse.cz>
References: <1354557873-21889-1-git-send-email-js1304@gmail.com> <1354557873-21889-2-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354557873-21889-2-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 03:04:33AM +0900, Joonsoo Kim wrote:
> We usually have interst in compiled files only,
> because they are strongly related to individual's work.
> Current tags.sh can't select compiled files, so support it.
> 
> We can use this functionality like below.
> "make cscope O=. SRCARCH=xxxx COMPILED_SOURCE=compiled"
> 
> It must be executed after building the kernel.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> ---
> v2: change bash specific '[[]]' to 'case in' statement.
>     use COMPILED_SOURCE env var, instead of abusing SUBARCH

Looks much better, I have only one minor nitpick:


> +	if [ "$COMPILED_SOURCE" = "compiled" ]; then
> +		all_compiled_sources

Please change it to -n "$COMPILED_SOURCE", so that COMPILED_SOURCE=1
works as well.

Michal
