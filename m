Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CYW40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:56:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39936 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab1CYW4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=g9YZHr9iQr8bh70gqliEXG5HG/KXBvcOl9BmHDzy5XKNsSpk/uBzpl7pOlrrWA7NZt
         drE3k4XaXBNOrb11GOGSHz5QbvvrJR/k5TJ6ePdglPEcxVCKZ56wU6eU6bM4MCibftiY
         4ZczPlkpG2uC61ZaDk/Ic1fHZdzyLRjA6o4i0=
MIME-Version: 1.0
In-Reply-To: <1301073283-30821-4-git-send-email-jamie@jamieiles.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com> <1301073283-30821-4-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 18:56:03 -0400
X-Google-Sender-Auth: HAsdXW4zEV24GROOydYj9aajcWk
Message-ID: <AANLkTin+Uvw8=CN+2oawAUHGot8gdM5u98S4zC8QoB=u@mail.gmail.com>
Subject: Re: [RFC PATCHv3 3/4] drivers/otp: convert bfin otp to generic OTP
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> +       /*
> +        * Skip the control pages then if we would run into the ECC area skip
> +        * past to the next data region.
> +        */
> +       raw_addr = region_addr + control_words;
> +       if (raw_addr > 0x80 * BFIN_OTP_WORDS_PER_PAGE)
> +               raw_addr += 0x20 * BFIN_OTP_WORDS_PER_PAGE;

mmm, no, we dont want to do that.  the Blackfin documentation is very
exact when it maps out pages, and we want the driver to match the
documentation.

but i guess in the other discussion we had, this would be removed anyways.

> +static int bfin_region_write_word(struct otp_region *region, unsigned long addr,
> +                                 u64 content)
> +{
> +       return -EACCES;
> +}

i think we'd just stub this out as NULL and let the common layer take
care of rejecting it ?

> +static const struct otp_device_ops bfin_otp_ops = {
> +       .name           = "BFIN",

guess this should be "bfin-otp"

> +static const struct otp_region_ops bfin_region_ops = {
> +       .read_word      = bfin_region_read_word,
> +       .write_word     = bfin_region_write_word,
> +       .get_size       = bfin_region_get_size,
> +       .get_fmt        = bfin_region_get_fmt,
> +       .ioctl          = bfin_region_ioctl,
> +};

hmm, i just realized this stuff is per-region.  wouldnt the
read/write/ioctl make more sense as per-device ?
-mike
