Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0GHMIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:08:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0GHMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:08:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 18/18] vfs: make no_llseek the default
Date: Thu, 8 Jul 2010 14:08:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-19-git-send-email-arnd@arndb.de> <201007082025.HDB82385.OOVHQSLtFFMFJO@I-love.SAKURA.ne.jp>
In-Reply-To: <201007082025.HDB82385.OOVHQSLtFFMFJO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081408.06415.arnd@arndb.de>
X-Provags-ID: V02:K0:Ksw6wKxq9p2sVYdSMNhXpPMY4vH7U/1bJPQR/KdVuyd
 Nm0uj+GDyTPqaLHmrKm5Odk4/pvgrrOJBg4QZCS1pDGQp+3uyH
 2B30TxiDe5B35jC2rgWczzS+k/yXi0skdPfIpirBxsVb4TEooX
 hbGAov4Gn3pOocE8mCESuXozYWEkhdVfX3/Ixc7LxA0+Gacmln
 E8Vtqmmyv78aRjOgeHMpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Tetsuo Handa wrote:
> Hello.
> 
> Arnd Bergmann wrote:
> > All file operations now have an explicit .llseek
> > operation pointer, so we can change the default
> > action for future code.
> 
> I saw patch for SELinux and IMA, but not for TOMOYO.
> TOMOYO has
> 
>   static const struct file_operations tomoyo_operations
> 
> without .llseek operation pointer.
> 
> TOMOYO does not deal offset pointer. Thus seek operation makes
> no sense. But returning -ESPIPE for seek operation might break
> some applications. What should I do for TOMOYO?

The semantic patch (16/18 in this series) had detected that case,
so I did not have to manually create a patch as for selinux
and ima.

The behaviour you want is noop_llseek, which is what gets used
when the semantic patch is applied. If you wish, you can
do the patch yourself and add .llseek = noop_llseek to the file
operations in your tree.

	Arnd
