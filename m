Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2FMAdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:33:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2FMAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:33:50 -0400
Date: Tue, 12 Jun 2012 17:33:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Paul Mundt <lethal@linux-sh.org>, Rafael <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus <magnus.damm@gmail.com>, Linux-SH <linux-sh@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: [PATCH] driver core: fixup reversed deferred probe order
Message-ID: <20120613003346.GB5321@kroah.com>
References: <20120529073313.GA21702@verge.net.au>
 <87k3zvmo4r.wl%kuninori.morimoto.gx@renesas.com>
 <20120529091129.GA26043@verge.net.au>
 <87txyy347i.wl%kuninori.morimoto.gx@renesas.com>
 <87sjei325k.wl%kuninori.morimoto.gx@renesas.com>
 <20120530013056.GA31474@verge.net.au>
 <87r4u2310j.wl%kuninori.morimoto.gx@renesas.com>
 <87pq9m30h1.wl%kuninori.morimoto.gx@renesas.com>
 <20120612231705.GB6177@kroah.com>
 <874nqg84do.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nqg84do.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:03:38PM -0700, Kuninori Morimoto wrote:
> 
> Hi Greg
> 
> Thank you for checking this patch
> 
> > > If driver requests probe deferral,
> > > it will be added to deferred_probe_pending_list
> > > by driver_deferred_probe_add(), but, it used list_add().
> > > Because of that, deferred probe will be run as reversed order.
> > > This patch uses list_add_tail(), and solved this issue.
> > 
> > Is this causing a problem with 3.5-rc2 on some systems, so it needs to
> > get into 3.5-final, or can it wait for 3.6?
> 
> ALSA SoC sound card detection order was broken by this issue in v3.5-rcX
> (on some board).
> So, I'm happy if it was included in v3.5-final.

Ok, thanks for letting me know, will queue it up for that release.

greg k-h
