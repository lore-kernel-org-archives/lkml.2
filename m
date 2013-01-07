Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3AGDCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:02:39 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53464 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3AGDCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:02:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130107024827.GZ27530@wantstofly.org>
References: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu> <20130107024827.GZ27530@wantstofly.org>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Sun, 6 Jan 2013 22:02:14 -0500
X-Google-Sender-Auth: 03WLlbrkQJd9aLKf7TGWh0vjP-Q
Message-ID: <CADGQE7EYbYqSkZZJfg-b0sF4w7GPrsGtXk+VBdWZ12Z7Xv7tcg@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 9:48 PM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> Good catch, but the patch would be better titled "mwl8k.c: avoid
> having a working driver", as the station_id return code _is_ needed
> by the caller in case of success.

I'm not quite sure what you mean -- is there something subtle going on
here?  I believe my patch preserves the semantics of the original
code: it returns the value of p->station_id if mwl8k_post_cmd()
returned 0, but it just does so by reading p->station_id first before
calling kfree(cmd).

Nickolai.
