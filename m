Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2JCPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:25:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48347 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab2JCPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:25:27 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Manuel Lauss <manuel.lauss@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] MIPS: Alchemy: use the OHCI platform driver
Date: Wed, 03 Oct 2012 17:24:25 +0200
Message-ID: <2608261.j829MQZAuC@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAOLZvyHyQGZ=Rs1=k07Saq16aZcntUe8N0Fc5iMoeOTeMpjcSw@mail.gmail.com>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-26-git-send-email-florian@openwrt.org> <CAOLZvyHyQGZ=Rs1=k07Saq16aZcntUe8N0Fc5iMoeOTeMpjcSw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012 17:21:37 Manuel Lauss wrote:
> On Wed, Oct 3, 2012 at 5:03 PM, Florian Fainelli <florian@openwrt.org> wrote:
> > This also greatly simplifies the power_{on,off} callbacks and make them
> > work on platform device id instead of checking the OHCI controller base
> > address like what was done in ohci-au1xxx.c.
> 
> That was by design -- the base address is far more reliable in identifying 
the
> correct controller instance than the platform device id.   There are systems
> in the field which don't use the alchemy/common/platform.c file at all.

Fair enough, but the way it was done previously was very error-prone if the 
base address changed for any reason in the platform code, and you did not 
notice it had to be changed in the OHCI driver too, then it simply did not 
work. By systems in the field you mean out of tree users? If so, I'd say that 
it's up to you to get them maintained or merged.
--
Florian
