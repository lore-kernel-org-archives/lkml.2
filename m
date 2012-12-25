Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2LYQqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:46:14 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45773 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:46:12 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 11:46:11 EST
Date: Tue, 25 Dec 2012 17:40:21 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rc-core: don't return from store_protocols without
 releasing device mutex
Message-ID: <20121225164021.GA13852@hardeman.nu>
Mail-Followup-To: Sasha Levin <sasha.levin@oracle.com>, mchehab@redhat.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1354971050-5784-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354971050-5784-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 07:50:50AM -0500, Sasha Levin wrote:
>Commit c003ab1b ("[media] rc-core: add separate defines for protocol bitmaps
>and numbers") has introduced a bug which allows store_protocols() to return
>without releasing the device mutex it's holding.
>
>Doing that would cause infinite hangs waiting on device mutex next time
>around.
>
>Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: David Härdeman <david@hardeman.nu>

>---
> drivers/media/rc/rc-main.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>index 601d1ac1..0510f4d 100644
>--- a/drivers/media/rc/rc-main.c
>+++ b/drivers/media/rc/rc-main.c
>@@ -890,7 +890,8 @@ static ssize_t store_protocols(struct device *device,
> 
> 		if (i == ARRAY_SIZE(proto_names)) {
> 			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
>-			return -EINVAL;
>+			ret = -EINVAL;
>+			goto out;
> 		}
> 
> 		count++;
>-- 
>1.8.0
>

-- 
David Härdeman
