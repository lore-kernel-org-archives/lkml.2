Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1LSCao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:30:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59573 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1LSCam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:30:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vitaly Kuznetsov <vitty@altlinux.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
References: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
Date: Sun, 18 Dec 2011 18:32:18 -0800
In-Reply-To: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru> (Vitaly Kuznetsov's
	message of "Wed, 14 Dec 2011 19:34:50 +0400")
Message-ID: <m162hdmgul.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/101O/t0HHlBIzuklWYex+2blfnt3qr4Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vitaly Kuznetsov <vitty@altlinux.ru>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] sysfs: change permissions for /sys from 0755 to 0555
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Kuznetsov <vitty@altlinux.ru> writes:

> There is a misleading difference between /proc and /sys permissions, /proc is
> 0555 and /sys is 0755. But
> as it is impossible to create or unlink something in /sys it would be nice to
> have same permissions.

Where does this difference matter?  This doesn't look like something
that could matter in practice.  If this does matter in practice this
change deserves a comment and a fuller explanation.

The change itself seems reasonable and probably worth making as general
cleanup.

Eric

> Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
> ---
>  fs/sysfs/mount.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 4974995..9d56fdd 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -36,7 +36,7 @@ struct sysfs_dirent sysfs_root = {
>         .s_name         = "",
>         .s_count        = ATOMIC_INIT(1),
>         .s_flags        = SYSFS_DIR,
> -       .s_mode         = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> +       .s_mode         = S_IFDIR | S_IRUGO | S_IXUGO,
>         .s_ino          = 1,
>  };
