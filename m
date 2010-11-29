Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0K2ECK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:02:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58179 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0K2ECI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:02:08 -0500
Date: Mon, 29 Nov 2010 13:01:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        kernel-janitors@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Magnus Damm <damm@opensource.se>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: boards: mach-se: use IS_ERR() instead of NULL check
Message-ID: <20101129040113.GA7594@linux-sh.org>
References: <1290791190-21358-1-git-send-email-segoon@openwall.com> <Pine.LNX.4.64.1011261835500.16655@axis700.grange> <20101126174533.GA29507@albatros> <20101127022315.GF7893@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101127022315.GF7893@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 11:23:15AM +0900, Paul Mundt wrote:
> On Fri, Nov 26, 2010 at 08:45:33PM +0300, Vasiliy Kulikov wrote:
> > Hi Guennadi,
> > 
> > On Fri, Nov 26, 2010 at 18:38 +0100, Guennadi Liakhovetski wrote:
> > > On Fri, 26 Nov 2010, Vasiliy Kulikov wrote:
> > > > clk_get() returns ERR_PTR() on error, not NULL.
> > > > 
> > > > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> > > 
> > > Yep, there are, probably, a couple more of these, similar to
> > 
> > I found a bit more, but I'd like to get feedback on these or just see it
> > applied first ;)
> > 
> It's a reasonable change, yes. The old clk_get() scanned multiple lists,
> and could return NULL or -ENOENT depending on which path failed. Now that
> everything is consolidated through the clk_get_sys() lookup, the NULL
> checks should probably all be replaced.

Anyways, I've applied this one now. Feel free to send updates for the
rest at your leisure.
