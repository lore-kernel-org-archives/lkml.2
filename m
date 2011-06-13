Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1FMUCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:02:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FMUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qkJXFsnCLbyZPnAVTIGnikvlhsrztwhBgq43U+SB6jbx3mLeYKNJO/J4w3ujgLAokN
         +Vmadmah8uoudFH2ucAxC8HeQNlB+4AQXRQTJ4/GYxeeGS9KUgq2UaEYcbb6eNGuP1CQ
         N1mpS5nfLt4bLnOxi6D1AyM5c9d9zUzd21Ndg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106121621360.25151@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106121621360.25151@swampdragon.chaosbits.net>
Date: Tue, 14 Jun 2011 00:02:38 +0400
Message-ID: <BANLkTikBnQADmUpP7J5gmJLXA9-O+4kSvw@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: Don't leak memory in ieee802154_nl_fill_phy
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Sergey Lapin <slapin@ossfans.org>,
        Maxim Osipov <maxim.osipov@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/11, Jesper Juhl <jj@chaosbits.net> wrote:
> In net/ieee802154/nl-phy.c::ieee802154_nl_fill_phy() I see two small
> issues.
> 1) If the allocation of 'buf' fails we may just as well return -EMSGSIZE
>    directly rather than jumping to 'out:' and do a pointless kfree(0).
> 2) We do not free 'buf' unless we jump to one of the error labels and this
>    leaks memory.
> This patch should address both.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

David, please commit this.

-- 
With best wishes
Dmitry
