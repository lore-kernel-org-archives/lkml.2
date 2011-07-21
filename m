Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1GUMKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:10:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1GUMKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:10:37 -0400
Date: Thu, 21 Jul 2011 14:10:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix potentially dangerous trailing ';' in #defined
 values/expressions
In-Reply-To: <1310645233-31889-1-git-send-email-ext-phil.2.carmody@nokia.com>
Message-ID: <alpine.LNX.2.00.1107211410160.7300@pobox.suse.cz>
References: <1310645233-31889-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Phil Carmody wrote:

> All these are instances of
>   #define NAME value;
> or
>   #define NAME(params_opt) value;
> 
> These of course fail to build when used in contexts like
>   if(foo $OP NAME)
>   while(bar $OP NAME)
> and may silently generate the wrong code in contexts such as
>   foo = NAME + 1;    /* foo = value; + 1; */
>   bar = NAME - 1;    /* bar = value; - 1; */
>   baz = NAME & quux; /* baz = value; & quux; */
>
> Reported on comp.lang.c,
> Message-ID: <ab0d55fe-25e5-482b-811e-c475aa6065c3@c29g2000yqd.googlegroups.com>
> Initial analysis of the dangers provided by Keith Thompson in that thread.
> 
> There are many more instances of more complicated macros having unnecessary
> trailing semicolons, but this pile seems to be all of the cases of simple
> values suffering from the problem. (Thus things that are likely to be found
> in one of the contexts above, more complicated ones aren't.)
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
