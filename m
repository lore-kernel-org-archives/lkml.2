Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2BMGvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:51:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60234 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752629Ab2BMGvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:51:45 -0500
Message-ID: <1329115904.30878.7.camel@joe2Laptop>
Subject: Re: [PATCH 2/2] bluetooth: Convert BT_DBG to pr_debug
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Sun, 12 Feb 2012 22:51:44 -0800
In-Reply-To: <1329115057.28848.52.camel@aeonflux>
References: <cover.1329102581.git.joe@perches.com>
	 <90fbd8a0b800c83f5ad1df7889dc9b11d7d9c588.1329102581.git.joe@perches.com>
	 <1329115057.28848.52.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 07:37 +0100, Marcel Holtmann wrote:
> > No need to obfuscate, just use the normal debugging macro.
> > Add "\n" to uses, align arguments, coalesce formats.
> > Fix a typo and fix a bad format extended by a line continuation.
> what is this patch buying us.

Easier greps of pr_debug.
BT_DBG is just an unnecessary useless wrapper.

> The only useful change would be to move to dev_printk, but we are not
> there yet.

Maybe dev_dbg, but there isn't always an
appropriate device * available.

There are many uses of:
	pr_debug("%s ...", (some struct hci_dev *)->name, ...)

that could be something like

hci_dev_dbg((some struct hci_dev *), fmt, ...)


