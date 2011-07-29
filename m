Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1G2U2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:28:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55282 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1G2U2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:28:17 -0400
Subject: Re: [patch] w1: off by one in w1_f29_remove_slave()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
In-Reply-To: <20110727095557.GL3824@shale.localdomain>
Date: Fri, 29 Jul 2011 16:28:12 -0400
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
References: <20110727095557.GL3824@shale.localdomain>
To: Dan Carpenter <error27@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup, confirmed, weird that I did not notice a crash, probably lucky shot in the environment I was using it.

On 2011-07-27, at 05:55, Dan Carpenter wrote:

> This reads past the end of the w1_f29_sysfs_bin_files[] array.  I
> don't have this hardware, but I assume it crashes every time the
> function is called.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jean-François Dagenais <dagenaisj@sonatest.com>
> 
> diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
> index c377818..0da4e97 100644
> --- a/drivers/w1/slaves/w1_ds2408.c
> +++ b/drivers/w1/slaves/w1_ds2408.c
> @@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
> static void w1_f29_remove_slave(struct w1_slave *sl)
> {
> 	int i;
> -	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
> +	for (i = NB_SYSFS_BIN_FILES - 1; i <= 0; --i)
> 		sysfs_remove_bin_file(&sl->dev.kobj,
> 			&(w1_f29_sysfs_bin_files[i]));
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

