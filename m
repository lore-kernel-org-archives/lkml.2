Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1EQTxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:53:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57719 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1EQTxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:53:12 -0400
Date: Tue, 17 May 2011 21:53:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
	tristate options
Message-ID: <20110517195310.GA17003@merkur.ravnborg.org>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
> For strings and integers, the config_is_xxx macros are useless and
> sometimes misleading:
> 
>   #define CONFIG_INITRAMFS_SOURCE ""
>   #define config_is_initramfs_source() 1

I'm late with this comment....
Could we introduce "config_is_foo" using a syntax that
does not break grepability?

Maybe a syntax like this?

    #ifdef CONFIG_FOO

and

    if (KCONFIG_FOO())

Grepping for the use of a symbol is a very typical thing,
so we should try to keep this.
And with the suggested syntax above I expect fixdep to
catch up both usage types.

	Sam
