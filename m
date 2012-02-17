Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BQUak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:30:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2BQUaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:30:39 -0500
Date: Fri, 17 Feb 2012 12:30:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
Message-Id: <20120217123037.ecfc5dd9.akpm@linux-foundation.org>
In-Reply-To: <20120217120815.25909.15632.stgit@zurg>
References: <4F3E42E0.4030108@openvz.org>
	<20120217120815.25909.15632.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 16:08:15 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Config NUMA must be defined for all architectures,
> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
> Some arch-specific Kconfig already has this stub.
> This patch adds it to all remaining.

It would be better to teach IS_ENABLED() to handle this situation.  I
don't think there's a way of doing this with cpp :(

This limitation makes IS_ENABLED pretty dangerous, doesn't it?  It
makes it very easy to introduce build breakage with unexpected Kconfig
combinations.


