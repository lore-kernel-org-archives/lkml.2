Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab0LUEDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:03:05 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40192 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933493Ab0LUEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:03:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bCoK6yqvKGy1dOm7FbfvBDBhg8l3ORla1rrKhV/CfZ/eAny0U5PdfjeyiZ9gqiIk9V10Ixc8UoVp6kkuz+S9y1wqJXJp0+9yGHpJx7iCKxQ6naLIYDtWh2UTARdLEeXm;
Date: Mon, 20 Dec 2010 20:02:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] vgaarb: use bridges to control VGA routing where
 possible. (v2)
Message-ID: <20101220200258.305889ec@jbarnes-desktop>
In-Reply-To: <1292803809-9200-1-git-send-email-airlied@gmail.com>
References: <1292803809-9200-1-git-send-email-airlied@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 10:10:09 +1000
Dave Airlie <airlied@gmail.com> wrote:

> - * @change_bridge: traverse ancestors and change bridges
> + * @change_bridge_flags: traverse ancestors and change bridges
> + * CHANGE_BRIDGE_ONLY / CHANGE_BRIDGE
>   */
>  int pci_set_vga_state(struct pci_dev *dev, bool decode,
> -		      unsigned int command_bits, bool change_bridge)
> +		      unsigned int command_bits, u32 flags)
>  {

Other than this nitpick, it looks sound to me; we'll need to actually
disable VGA decode in the shared bridge hierarchy case rather than just
using simple bridge routing.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
