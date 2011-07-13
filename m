Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GMM4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:56:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1GMM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:56:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/2] TTY: ami_serial, remove BTM from wait_until_sent
Date: Wed, 13 Jul 2011 14:56:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andreas Bombe <aeb@debian.org>
References: <201107122325.35013.arnd@arndb.de> <1310553086-27427-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310553086-27427-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107131456.28333.arnd@arndb.de>
X-Provags-ID: V02:K0:VQQ9vNbKL8yXH5xSbuT3gOveUKKxnRgXCtniazT670o
 MH2s6coPBrg4BNgDoUE01ILeowBSswBMZafVX4zjJPnaPi2IpA
 bpyyIBuzYU+B/kdQvy96uREqF8CFsHdErrQFIOp3S8vyUsMiR2
 silTYgUVMHctZlAOKe73j2UmM14AwcaqrrPIR9/3yW9pKw9AkH
 T26Q4qGtKtQfiAvhGg2Jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 July 2011, Jiri Slaby wrote:
> The same as in "TTY: serial, remove BTM from wait_until_sent" we don't
> need to take BTM in wait_until_sent of ami_serial. Exactly the same
> as serial, ami_serial accesses some "info" members (xmit_fifo_size,
> timeout), but their assignment on other places in the code is not
> protected by BTM anyway.
> 
> So the BTM protects nothing here. This removal helps us to get rid of
> tty_locked() and __big_tty_mutex_owner in the following patch. This
> was suggested by Arnd.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Andreas Bombe <aeb@debian.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
