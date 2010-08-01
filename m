Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0HAKyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:54:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0HAKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ys1AMLfoZ+mowOlUZouyEosIuUYftGMQHCuHchQYTztgcXt7RYvlv8smQZJTpvo1gD
         vdBIa8FQSkKubxsGrhFq6s6JzxHO09slN9xl7MGnfHh+qUWP7NHPBYtCSoP2xg5GmcjX
         7IqcVCG1Z35txYlSKmDkTjNPEv0FXSFsLpsmM=
Date: Sun, 1 Aug 2010 14:54:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Scott Wood <scottwood@freescale.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Dave Jiang <djiang@mvista.com>, linuxppc-dev@ozlabs.org,
        Doug Thompson <dougthompson@xmission.com>
Subject: [PATCH] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC
 controllers (fix)
Message-ID: <20100801105419.GA352@oksana.dev.rtsoft.ru>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
 <20100716151224.21d499a3@schlenkerla.am.freescale.net>
 <20100721153933.64d02086.akpm@linux-foundation.org>
 <20100721182108.5a22c822@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100721182108.5a22c822@schlenkerla.am.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 06:21:08PM -0500, Scott Wood wrote:
[...]
> > > > +	{ .compatible = "fsl,p4080-l2-cache-controller", },
> > >
> > > L2 on the p4080 is quite different from those other chips.  It's part
> > > of the core, controlled by SPRs.
> >
> > erm, was that an ack or a nack?
>
> NACK, p4080 doesn't belong in this table, at least not its L2.
>
> L3 on p4080 is similar to L2 on these other chips, though, and it
> wouldn't take much to get this driver working on it -- but the match
> table entry should wait until the differences are accommodated.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

Scott, thanks for catching this!

Andrew, please merge this patch into
edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch

Thanks!

 drivers/edac/mpc85xx_edac.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index cfa86f7..b178cfa 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -652,7 +652,6 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
 	{ .compatible = "fsl,p1020-l2-cache-controller", },
 	{ .compatible = "fsl,p1021-l2-cache-controller", },
 	{ .compatible = "fsl,p2020-l2-cache-controller", },
-	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
-- 
1.7.0.5

