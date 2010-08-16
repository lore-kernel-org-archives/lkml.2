Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0HPVE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:04:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0HPVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JXFVALmO91hb1rtzv2mcP9BXpJZQIMusB1qN2CPs1dJsUlpA4Wb9Df1ljX3XdVhgqR
         yaiIa+ZHORwPPqutjtKVc23oWHpK7OY8bLHgBajAPcsux60YuxYpcqIFwCZ0Z9f3QBLJ
         urpUrVB/cI4TKSzUA/jgfrScmIb7oZAadpgHA=
MIME-Version: 1.0
Date: Mon, 16 Aug 2010 21:04:25 +0000
Message-ID: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com>
Subject: BUG: nconfig doesn't preserve case in its menu display
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
To: Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I do "make nconfig" and go to "General Setup" my "Local version -
append to kernel release" entry appears as:

    (-avar-akbar) Local version - append to kernel release

When I use "make menuconfig" it's:

    (-Avar-Akbar) Local version - append to kernel release

And my .config agrees:

    $ ack -n1 CONFIG_LOCALVERSION .config
    CONFIG_LOCALVERSION="-Avar-Akbar"

But when I edit the version string in both menuconfig and nconfig it
retains the correct casing.

I briefly searched through the nconfig code, but couldn't find
anything pertinent to the localversion, so this is probably a more
general issue.
