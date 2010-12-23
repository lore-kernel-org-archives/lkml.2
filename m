Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0LWR3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:29:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44949
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab0LWR3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:29:52 -0500
Date: Thu, 23 Dec 2010 09:30:22 -0800 (PST)
Message-Id: <20101223.093022.193727098.davem@davemloft.net>
To: jeffm@suse.com
CC: linux-kernel@vger.kernel.org
Subject: taskstats alignment...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Re: commit 4be2c95d1f7706ca0e74499f2bd118e1cee19669

Pretty much every 64-bit architecture other than
powerpc64 and x86-64 needs that code, not just
IA64.

Better check would be:

CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS

Otherwise we'll be twiddling that ifdef endlessly as each
and every other 64-bit platform bumps into this issue.

So please could you change this to use a more sane check?

Thanks!
