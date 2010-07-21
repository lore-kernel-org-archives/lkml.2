Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663Ab0GUGhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:37:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38944
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758713Ab0GUGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:37:14 -0400
Date: Tue, 20 Jul 2010 23:37:30 -0700 (PDT)
Message-Id: <20100720.233730.93399247.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, jkacur@redhat.com, fweisbec@gmail.com
Subject: Re: [PATCH 08/12] sbus: autoconvert trivial BKL users to private
 mutex
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278883143-29035-9-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
	<1278883143-29035-9-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 11 Jul 2010 23:18:59 +0200

> All these files use the big kernel lock in a trivial
> way to serialize their private file operations,
> typically resulting from an earlier semi-automatic
> pushdown from VFS.
> 
> None of these drivers appears to want to lock against
> other code, and they all use the BKL as the top-level
> lock in their file operations, meaning that there
> is no lock-order inversion problem.
> 
> Consequently, we can remove the BKL completely,
> replacing it with a per-file mutex in every case.
> Using a scripted approach means we can avoid
> typos.
...
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
