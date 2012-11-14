Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945977Ab2KNXLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:11:08 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41155 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1945931Ab2KNXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:11:07 -0500
Date: Wed, 14 Nov 2012 15:11:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] x86/Sandy Bridge: reserve pages when
 integrated graphics is present
Message-ID: <20121114151134.2df4d666@jbarnes-desktop>
In-Reply-To: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 20:43:31 +0000
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> SNB graphics devices have a bug that prevent them from accessing certain
> memory ranges, namely anything below 1M and in the pages listed in the
> table.  So reserve those at boot if set detect a SNB gfx device on the
> CPU to avoid GPU hangs.
> 
> Stephane Marchesin had a similar patch to the page allocator awhile
> back, but rather than reserving pages up front, it leaked them at
> allocation time.

So if people are seeing seemingly random hangs with SNB, please give
this patch a try.  These issues aren't easy to hit, and they're
frustratingly hard to debug, but with some long runtime maybe it'll
give people some confidence.

-- 
Jesse Barnes, Intel Open Source Technology Center
