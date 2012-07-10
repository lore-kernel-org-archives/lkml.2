Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2GJOHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:07:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:21713 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2GJOHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="190753153"
Date: Tue, 10 Jul 2012 17:06:58 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v2 1/8] /proc/net/ entries for bluetooth protocols
Message-ID: <20120710140656.GB15795@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120615080007.GD7205@aemeltch-MOBL1>
 <20120618.190014.158443124058398316.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618.190014.158443124058398316.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Mon, Jun 18, 2012 at 07:00:14PM +0900, Masatake YAMATO wrote:
> (I reflected the result of reviewing by Andrei.)
> 
> lsof command can tell the type of socket processes are using.
> Internal lsof uses inode numbers on socket fs to resolve the type of
> sockets. Files under /proc/net/, such as tcp, udp, unix, etc provides
> such inode information.
> 
> Unfortunately bluetooth related protocols don't provide such inode
> information. This patch series introduces /proc/net files for the protocols.
> 
> This patch against af_bluetooth.c provides facility to the implementation
> of protocols. This patch extends bt_sock_list and introduces two exported
> function bt_procfs_init, bt_procfs_cleanup.
> 
> The type bt_sock_list is already used in some of implementation of
> protocols. bt_procfs_init prepare seq_operations which converts
> protocol own bt_sock_list data to protocol own proc entry when the
> entry is accessed.
> 
> What I, lsof user, need is just inode number of bluetooth
> socket. However, people may want more information. The bt_procfs_init
> takes a function pointer for customizing the show handler of
> seq_operations.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  include/net/bluetooth/bluetooth.h |   10 +++
>  net/bluetooth/af_bluetooth.c      |  136 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 146 insertions(+)
> 
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index 961669b..9c44977 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -30,6 +30,7 @@
>  #include <linux/list.h>

The line above was removed by commit

commit 8c520a59927a5600973782505dbb750d985057c4
Author: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date:   Wed May 23 04:04:22 2012 -0300

    Bluetooth: Remove unnecessary headers include

Best regards 
Andrei Emeltchenko 

