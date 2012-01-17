Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2AQXrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:47:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2AQXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:47:09 -0500
Date: Tue, 17 Jan 2012 15:47:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Message-Id: <20120117154702.d009df12.akpm@linux-foundation.org>
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 07:32:47 +0000
"AnilKumar, Chimata" <anilkumar@ti.com> wrote:

> Hi All,
> 
> Recalling the patch, provide the comments if there are any if not please include
> this patch to v3.3 kernel.

The patch is all mangled by someone's email client.  Wordwrapping, mime
crap which my MUA can't decrypt, etc.

> -----Original Message-----
> From: AnilKumar, Chimata 
> Sent: Friday, December 23, 2011 10:55 AM
> To: arnd@arndb.de; greg@kroah.com; eric.piel@tremplin-utc.net; akpm@linux-foundation.org; broonie@opensource.wolfsonmicro.com; linux-kernel@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; Nori, Sekhar; AnilKumar, Chimata

A pet peeve which I haven't told anyone about.  If you've cc'ed someone
on a patch then I want to cc them on the patch too.  That means I have
to add their Cc: lines to the changelog.  But such Cc: lines include
their real names.  By omitting their real names in the above fashion,
you cause extra hassle for me.  Ideally, you should add their Cc: to
the changelog as well as to the mail headers, to give thsoe people the
best chance of seeing what is happening with the patch.

>
> ..
>
> +static ssize_t lis3lv02d_range_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	lis3lv02d_sysfs_poweron(&lis3_dev);
> +	return sprintf(buf, "%d\n", lis3_dev.g_range);
> +}

Are these interfaces documented anywhere?  If so, please update that
documentation.  If not, why not ;)

> @@ -809,15 +881,33 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t lis3lv02d_range_set(struct device *dev,
> +				struct device_attribute *attr, const char *buf,
> +				size_t count)
> +{
> +	unsigned long range;
> +
> +	if (strict_strtoul(buf, 0, &range))

checkpatch would have told you that strict_strtoul() is deprecated. 
Please always use checkpatch.

