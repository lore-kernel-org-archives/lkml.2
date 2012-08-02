Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2HBH2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:28:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53196 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2HBH2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:28:00 -0400
Date: Thu, 02 Aug 2012 00:27:59 -0700 (PDT)
Message-Id: <20120802.002759.225229908260811459.davem@davemloft.net>
To: jkosina@suse.cz
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc64: do not clobber personality flags in
 sys_sparc64_personality()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012204140.14910@pobox.suse.cz>
	<alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 2 Aug 2012 09:12:46 +0200 (CEST)

> From 4f000eda5917ceecb03767962026cc6a390b8216 Mon Sep 17 00:00:00 2001
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Wed, 1 Aug 2012 21:10:51 +0200
> Subject: [PATCH 4/4] sparc64: do not clobber personality flags in sys_sparc64_personality()
> 
> There are multiple errors in how sys_sparc64_personality() handles
> personality flags stored in top three bytes.
> 
> - directly comparing current->personality against PER_LINUX32 doesn't work
>   in cases when any of the personality flags stored in the top three bytes
>   are used.
> - directly forcefully setting personality to PER_LINUX32 or PER_LINUX
>   discards any flags stored in the top three bytes
> 
> Fix the first one by properly using personality() macro to compare only
> PER_MASK bytes.
> Fix the second one by setting only the bits that should be set, instead of
> overwriting the whole value.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Applied, thanks a lot Jiri.
