Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab2FLXRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:17:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2FLXRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:17:10 -0400
Date: Tue, 12 Jun 2012 16:17:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Paul Mundt <lethal@linux-sh.org>, Rafael <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus <magnus.damm@gmail.com>, Linux-SH <linux-sh@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: [PATCH] driver core: fixup reversed deferred probe order
Message-ID: <20120612231705.GB6177@kroah.com>
References: <20120529064621.GB6166@verge.net.au>
 <20120529070458.GB11445@linux-sh.org>
 <20120529073313.GA21702@verge.net.au>
 <87k3zvmo4r.wl%kuninori.morimoto.gx@renesas.com>
 <20120529091129.GA26043@verge.net.au>
 <87txyy347i.wl%kuninori.morimoto.gx@renesas.com>
 <87sjei325k.wl%kuninori.morimoto.gx@renesas.com>
 <20120530013056.GA31474@verge.net.au>
 <87r4u2310j.wl%kuninori.morimoto.gx@renesas.com>
 <87pq9m30h1.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq9m30h1.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:46:06PM -0700, Kuninori Morimoto wrote:
> If driver requests probe deferral,
> it will be added to deferred_probe_pending_list
> by driver_deferred_probe_add(), but, it used list_add().
> Because of that, deferred probe will be run as reversed order.
> This patch uses list_add_tail(), and solved this issue.

Is this causing a problem with 3.5-rc2 on some systems, so it needs to
get into 3.5-final, or can it wait for 3.6?

thanks,

greg k-h
