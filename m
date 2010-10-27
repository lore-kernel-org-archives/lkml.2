Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab0J0QZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:25:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64387 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0J0QZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HeSIPJW57jODNNSXEzPhLLobCQraV51Okc0APIzq6gKbS6rODpHhepeb683pkAO25I
         rPyuctHttyjoiuMxO5vk0iBSfYHtqt4IATGQoVWWv6YYs3DZxkeh3N/QhAXGSQwMCmtC
         orD83eUO3SJRnsdjac9ciL2AGsaupq2RHEhDY=
MIME-Version: 1.0
In-Reply-To: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
Date: Wed, 27 Oct 2010 14:25:44 -0200
Message-ID: <AANLkTinc50bzQawaoA_XfkLhJXjVjPWzxgbCJ40UnYwi@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
From: Thiago Farina <tfransosi@gmail.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:09 PM, Sundar Iyer
<sundar.iyer@stericsson.com> wrote:
> +static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
> +{
> +       int regulator_id, ret;
> +       struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
> +
> +       regulator_id = rdev_get_id(rdev);
> +       if (regulator_id >= AB8500_NUM_REGULATORS)
> +               return -EINVAL;
> +
> +       ret = ab8500_read(info->ab8500, info->update_reg);
> +       if (ret < 0) {
> +               dev_dbg(rdev_get_dev(rdev),
> +                       "couldnt read 0x%x register\n", info->update_reg);
> +               return ret;
> +       }
> +
> +       if (ret & info->mask)
> +               return true;
> +       else
> +               return false;
> +}

Shouldn't be this returning 1 instead of true and 0 instead false
(since the return type is int not bool)?

Maybe like this?
return (ret & info->mask) ? 1: 0;
