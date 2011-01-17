Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863Ab1AQFDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 00:03:01 -0500
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:45060 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1AQFC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 00:02:57 -0500
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI5cM02tJV2Z/2dsb2JhbACkX3OmQ5gohVAEhHCGLw
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: question about smatch error
X-Message-Flag: Warning: May contain useful information
Date: Sun, 16 Jan 2011 21:02:52 -0800
Message-ID: <adar5ccyver.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I'm running smatch against some of my code, and I'm seeing the errors

drivers/infiniband/hw/mlx4/main.c +784 mlx4_addrconf_ifid_eui48(5) error: buffer overflow 'eui' 3 <= 3
drivers/infiniband/hw/mlx4/main.c +785 mlx4_addrconf_ifid_eui48(6) error: buffer overflow 'eui' 3 <= 4
drivers/infiniband/hw/mlx4/main.c +787 mlx4_addrconf_ifid_eui48(8) error: buffer overflow 'eui' 3 <= 3
drivers/infiniband/hw/mlx4/main.c +788 mlx4_addrconf_ifid_eui48(9) error: buffer overflow 'eui' 3 <= 4

and I can't understand what smatch is trying to say -- the code in
question is basically

	if (vlan_id < 0x1000) {
		eui[3] = vlan_id >> 8;
		eui[4] = vlan_id & 0xff;
	} else {
		eui[3] = 0xff;
		eui[4] = 0xfe;
	}

where eui is a u8*, and I don't see how smatch even thinks it knows how
big the buffer is in the first place.

This is with up-to-date smatch from git (my tree is at 798c4c13).

Thanks,
  Roland
