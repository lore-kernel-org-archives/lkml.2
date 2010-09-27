Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab0I0WGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:06:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63665 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0I0WGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nOSP4UABLd7/d3oJlAFhhOy5PxjiW0LlikgHrJOwgOFBsLtr+ATm/NW8GZSrxIQ4QW
         3e92klAskFBO1Vq9f3m0xmwKH86jGMoLGnMxUG6Jiyx6xtFsHC0ZdMNxKwoZDbBgs4eu
         Q61feMd6/CI9rcsziCJ+hWpEvs/4D/TQXOlE4=
Message-ID: <4CA11546.8@pobox.com>
Date: Mon, 27 Sep 2010 18:05:58 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] de2104x: fix ethtool
References: <201009272341.50668.linux@rainbow-software.org>
In-Reply-To: <201009272341.50668.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 05:41 PM, Ondrej Zary wrote:
> When the interface is up, using ethtool breaks it because:
> a) link is put down but media_timer interval is not shortened to NO_LINK
> b) rxtx is stopped but not restarted
>
> Also manual 10baseT-HD (and probably FD too - untested) mode does not work -
> the link is forced up, packets are transmitted but nothing is received.
> Changing CSR14 value to match documentation (not disabling link check) fixes this.
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

Good catch on the missing de_start_rxtx()


