Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0GMLrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:47:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0GMLrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:47:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martyn Welch <martyn.welch@ge.com>
Subject: Re: [PATCH 01/12] staging: autoconvert trivial BKL users to private mutex
Date: Tue, 13 Jul 2010 13:46:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org
References: <1278883143-29035-1-git-send-email-arnd@arndb.de> <1278883143-29035-2-git-send-email-arnd@arndb.de> <4C3C2387.3090900@ge.com>
In-Reply-To: <4C3C2387.3090900@ge.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007131346.53926.arnd@arndb.de>
X-Provags-ID: V02:K0:Y4quF/cgY8Bw3UGkGXYGy/4xp15B9HhqkffkIdfpHKB
 SQ5eJThdlnZJ3a9tegoPiWJY6+Ggstb7tcbybcGE4HAS/P1/D1
 5aNZkhCwHlCUQWG4vqXzCo40JzGrBg4YMe8OFsc7hpv88bsiiZ
 1r0hdAK1N0FUTRC6Yt8+NfM14fRH0DMN6xzvN23cJBeQFQlhp+
 NZLKKAASIsrSbAIVrV1YQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 July 2010, Martyn Welch wrote:

> > -     lock_kernel();
> > +     mutex_lock(&vme_user_mutex);
> >       ret = vme_user_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> > -     unlock_kernel();
> > +     mutex_unlock(&vme_user_mutex);
> >   
> 
> Wha!, where'd that come from!!??
> 
> Ah, OK - "Staging: push down BKL into ioctl functions", missed that,
> looks fine.
> <http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=b1f2ac07636aadee5cb077fc7e830908b00fcaae>
> 

Both patches only did blind conversions to drive the BKL out. Feel free to
kill off that mutex and the vme_user_unlocked_ioctl() function in there again
if you are convinced that no locking is actually needed in there.

	Arnd
