Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1EJMIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:08:12 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53521 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab1EJMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:08:10 -0400
Subject: Re: [PATCH] omap2/omapfb: make DBG() more resistant in if-else
 constructions
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Niels de Vos <ndevos@redhat.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
References: <1305019249-9898-1-git-send-email-ndevos@redhat.com>
	 <BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 15:08:05 +0300
Message-ID: <1305029285.2045.38.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 11:42 +0200, Geert Uytterhoeven wrote:

> What about using the standard pr_debug()/dev_dbg() instead?
> With dynamic debug, it can be enabled at run time.
> As a bonus, you get printf()-style format checking if debugging is disabled.

Yes, dev_dbg & co. would be better.

However, one thing I dislike about them is the extra stuff they print.
For example, for omapfb and omapdss dev_dbg will print:

omapfb omapfb: foo
omapdss_dss omapdss_dss: foo

I originally added the debug macros to omapdss to be able to
automatically print the DSS module name, as at that point there was only
one big omapdss device. And I guess I just followed with similar macro
in omapfb also. But I believe both omapdss and omapfb should be changed
to dev_* prints sometime soon.

 Tomi


