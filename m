Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1HQSnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:43:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58096 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1HQSnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:43:05 -0400
References: <20110727095557.GL3824@shale.localdomain> <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com> <CAOmT4fS1OqQb5KOOeFnGHt1tnYGBRutVrAZ4cXB6n=hou5fn8w@mail.gmail.com> <20110730081958.GA5575@shale.localdomain>
In-Reply-To: <20110730081958.GA5575@shale.localdomain>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <CC07C792-D6D1-4D76-8384-14470E5B0075@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: bojan prtvar <prtvar.b@gmail.com>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: [patch v2] w1: fix for loop in w1_f29_remove_slave()
Date: Wed, 17 Aug 2011 14:45:06 -0400
To: Dan Carpenter <error27@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The for loop was looking for i <= 0 instead of i >= 0 so this
> function never did anything.  Also we started with i =
> NB_SYSFS_BIN_FILES instead of "NB_SYSFS_BIN_FILES - 1" which is an
> off by one bug.
> 
> Reported-by: Bojan Prtvar <prtvar.b@gmail.com>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jean-François Dagenais <dagenaisj@sonatest.com>
> ---
> v2:  fix >= vs <=
> 
> diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
> index c377818..7c8cdb8 100644
> --- a/drivers/w1/slaves/w1_ds2408.c
> +++ b/drivers/w1/slaves/w1_ds2408.c
> @@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
> static void w1_f29_remove_slave(struct w1_slave *sl)
> {
> 	int i;
> -	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
> +	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
> 		sysfs_remove_bin_file(&sl->dev.kobj,
> 			&(w1_f29_sysfs_bin_files[i]));
> }

