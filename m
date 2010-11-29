Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0K2KSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:18:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0K2KSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:18:06 -0500
From: Andi Kleen <andi@firstfloor.org>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
References: <4CF30B46.4000203@pavlinux.ru>
Date: Mon, 29 Nov 2010 11:18:00 +0100
In-Reply-To: <4CF30B46.4000203@pavlinux.ru> (Pavel Vasilyev's message of "Mon,
	29 Nov 2010 05:09:10 +0300")
Message-ID: <87eia4l9gn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Vasilyev <pavel@pavlinux.ru> writes:

>     This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).

Those two calls are not equivalent. Think what happens when a or b
are shorter than n and one of them is at the end of a page 
before a memory hole.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
