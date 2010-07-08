Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab0GHLZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:25:19 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58344 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0GHLZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:25:17 -0400
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 18/18] vfs: make no_llseek the default
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	<1278538820-1392-19-git-send-email-arnd@arndb.de>
In-Reply-To: <1278538820-1392-19-git-send-email-arnd@arndb.de>
Message-Id: <201007082025.HDB82385.OOVHQSLtFFMFJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 8 Jul 2010 20:25:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Arnd Bergmann wrote:
> All file operations now have an explicit .llseek
> operation pointer, so we can change the default
> action for future code.

I saw patch for SELinux and IMA, but not for TOMOYO.
TOMOYO has

  static const struct file_operations tomoyo_operations

without .llseek operation pointer.

TOMOYO does not deal offset pointer. Thus seek operation makes
no sense. But returning -ESPIPE for seek operation might break
some applications. What should I do for TOMOYO?

Regards.
