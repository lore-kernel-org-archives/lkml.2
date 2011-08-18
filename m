Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1HRDFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:05:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1HRDE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:04:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Da8v+m2K31M3TG6lA/pBE3iKhrmMdnNxp80vOotsVmXB+1NJLcjWk4nTk55I4fomY
	G5RBHp5uhObL1zPT6DGKw==
MIME-Version: 1.0
In-Reply-To: <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 11:04:35 +0800
X-Google-Sender-Auth: rCYp6T1J3y9Une0VSmfJhrlcPYo
Message-ID: <CAGS+omDVn1uoU85pPN+jeHMTMp83EA13b3E8Sca0QOqDBZHQFg@mail.gmail.com>
Subject: Re: [PATCH 5/6] Input: elantech - clean up elantech_init
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 9:57 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> Group property setting code into elantech_set_properties.
>
> Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
> ---
>  drivers/input/mouse/elantech.c |   69 ++++++++++++++++++++++-----------------
>  1 files changed, 39 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 7b9b6e5..ddd40eb 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -791,6 +791,42 @@ static int elantech_reconnect(struct psmouse *psmouse)
>  }
>
>  /*
> + * determine hardware version and set some properties according to it.
> + */
> +static void elantech_set_properties(struct elantech_data *etd)
> +{
> +       /*
> +        * Assume every version greater than 0x020030 is new EeePC style
> +        * hardware with 6 byte packets, except 0x020600
> +        */
> +       if (etd->fw_version < 0x020030 || etd->fw_version == 0x020600)
> +               etd->hw_version = 1;
> +       else
> +               etd->hw_version = 2;
> +
> +       /*
> +        * Turn on packet checking by default.
> +        */
> +       etd->paritycheck = 1;

Assuming paritycheck goes away:

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
