Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2HPI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:57:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62608 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2HPI5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:57:18 -0400
Date: Thu, 16 Aug 2012 11:57:13 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
Message-ID: <20120816115713.726da8f2@pixies.home.jungo.com>
In-Reply-To: <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	<1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Sorry for reviewing this late...

On Tue, 10 Jul 2012 18:23:42 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> -config MTD_UBI_BEB_LIMIT
> -	int "Maximum expected bad eraseblocks per 1024 eraseblocks"
> -	default 20
> -	range 2 256

I see some benefit keeping the config.

For the simplest systems (those having one ubi device) that need a limit
*other* than the default (20 per 1024), they can simply set the config
to their chosen value, as they were used to.

With you approach, these system MUST pass the limit parameter via the
ioctl / module-parameter.

> +static int get_bad_peb_limit(const struct ubi_device *ubi, int max_beb_per1024)
> +{
> +	int device_peb_count;
> +	uint64_t device_size;
> +	int beb_limit = 0;
> +
> +	/* this has already been checked in ioctl */
> +	if (max_beb_per1024 <= 0)
> +		goto out;

Can you explain how 'max_beb_per1024 <= 0' may happen? 

It seems that all of your calls to 'ubi_attach_mtd_dev' pass a positive
max_beb_per1024 value (the default is always set). See your
'ubi_mtd_param_parse' and 'ctrl_cdev_ioctl'. Am I missing something?

Also, since max_beb_per1024 is always set, how one may specify a zero
limit?

Regards,
Shmulik
