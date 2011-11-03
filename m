Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab1KCQrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:47:13 -0400
Received: from claw.goop.org ([74.207.240.146]:45401 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934045Ab1KCQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:47:12 -0400
Message-ID: <4EB2C591.6070202@goop.org>
Date: Thu, 03 Nov 2011 09:47:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ben Guthro <ben@guthro.net>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <CAOvdn6VfZ524ku2DBMfmTV+dHGXrSV8Ls_iwHdm=ESXO9kUjcg@mail.gmail.com>
In-Reply-To: <CAOvdn6VfZ524ku2DBMfmTV+dHGXrSV8Ls_iwHdm=ESXO9kUjcg@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 08:06 AM, Ben Guthro wrote:
> After pulling in this change from your tree, I found the following
> bug, when checking an enum value, which should be considered before
> inclusion:
>
>
> diff --git a/arch/x86/kernel/microcode_xen.c
> b/arch/x86/kernel/microcode_xen.c
> index 9d2a06b..6a73957 100644
> --- a/arch/x86/kernel/microcode_xen.c
> +++ b/arch/x86/kernel/microcode_xen.c
> @@ -157,7 +157,7 @@ static enum ucode_state
> xen_request_microcode_user(int cpu,
>  ret = UCODE_OK;
>  
>  out:
> -if (ret == 0)
> +if (ret == UCODE_OK)
>  uci->mc = uc;
>  else
>  vfree(uc);

Thanks!

    J

