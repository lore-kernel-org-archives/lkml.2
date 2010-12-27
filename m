Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0L0TmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 14:42:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55146 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0L0TmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 14:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I3Nuea79ujmjEDK0B05wW7SLXUsn1txvgHBrbrTdNgYRbqOzswhhSNw+bpaPx+jrlV
         XjO/mxxogQeAGyOFvcVxtnEpB3IV5KJ0NgrfhjD2FX+HnNVMLUd+l6g5dYZht5gckJCQ
         hs4ciNsC5VReN2B6Nw1ipByuX1fpDpAWM1eI4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012170307080.20940@x980>
References: <20101214220932.GA1206@sgi.com>
	<alpine.LFD.2.00.1012141903210.25387@x980>
	<20101215024136.GB19601@sgi.com>
	<alpine.LFD.2.00.1012142302110.4878@x980>
	<20101215164635.GA27373@sgi.com>
	<alpine.LFD.2.00.1012151536510.21167@x980>
	<alpine.LFD.2.00.1012162149370.20940@x980>
	<alpine.LFD.2.00.1012170307080.20940@x980>
Date: Mon, 27 Dec 2010 11:42:18 -0800
X-Google-Sender-Auth: i1geq1X_PXsYfxaJ-VSmssNxXwg
Message-ID: <AANLkTin7WmYo47JvCMSjExkZ8o2rPajB3fOxU80-UdE1@mail.gmail.com>
Subject: Re: [PATCH] ACPI: use ioremap_cache()
From: Tony Luck <tony.luck@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, hpa@zytor.com,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 12:08 AM, Len Brown <lenb@kernel.org> wrote:
> No change on ia64.

Apart from breaking the build :-(

> +++ b/arch/ia64/include/asm/io.h
   ...
> +static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
> +{
> +       return ioremap(unsigned long phys_addr, unsigned long size);
> +}

Cut & paste issue? ... the compiler would be a lot happier
without the "unsigned long"s in the call to ioremap().

-Tony
