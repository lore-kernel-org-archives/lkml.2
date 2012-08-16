Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2HPStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:49:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49864 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HPSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
Date: Thu, 16 Aug 2012 14:49:28 -0400
Message-ID: <CA+5PVA4i6CYNmxbHHfgEYqPHVD=_PDqurFyrZzzL5jb0rdVj8w@mail.gmail.com>
Subject: Re: [RFC v2 4/7] modsig: add integrity_module_check hook
From: Josh Boyer <jwboyer@gmail.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> @@ -2437,6 +2438,14 @@ static int copy_and_check(struct load_info *info,
>
>         info->hdr = hdr;
>         info->len = len;
> +
> +       err = integrity_module_check(hdr, len);
> +       if (err < 0)
> +               goto free_hdr;
> +
> +       /* cut signature tail */
> +       info->len = err;
> +
>         return 0;
>
>  free_hdr:

So if I'm reading this correctly, any module that fails signature
verification will fail to load.  That makes sense, but I wonder if you
intend to support a non-enforcing mode for module signatures at all?
Actually, a brief document in Documentation describing how this whole
mechanism works and what the fail states are would be good.  David's
patches have it nicely spelled out and I don't see anything similar in
your patch set.

josh
