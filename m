Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2BMMuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 07:50:15 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53912 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2BMMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 07:50:13 -0500
Subject: Re: [PATCH 03/13] firewire-sbp-target: Add Kconfig, Makefile and
 TODO
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de
In-Reply-To: <1328989452-20921-4-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	 <1328989452-20921-1-git-send-email-bootc@bootc.net>
	 <1328989452-20921-4-git-send-email-bootc@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 04:50:10 -0800
Message-ID: <1329137410.9333.389.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 19:44 +0000, Chris Boot wrote:
> The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
> as a SCSI transport. This module uses the SCSI Target framework to
> expose LUNs to other machines attached to a FireWire bus, in effect
> acting as a FireWire hard disk similar to FireWire Target Disk mode on
> older Apple computers.
> 
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: Andy Grover <agrover@redhat.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>
> Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/target/sbp/Kconfig  |   14 ++++++++++++++
>  drivers/target/sbp/Makefile |   13 +++++++++++++
>  drivers/target/sbp/TODO     |    7 +++++++
>  3 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/sbp/Kconfig
>  create mode 100644 drivers/target/sbp/Makefile
>  create mode 100644 drivers/target/sbp/TODO
> 
> diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
> new file mode 100644
> index 0000000..8544010
> --- /dev/null
> +++ b/drivers/target/sbp/Kconfig
> @@ -0,0 +1,14 @@
> +
> +config FIREWIRE_SBP_TARGET
> +	tristate "FireWire SBP-2 fabric module"
> +	depends on TARGET_CORE && CONFIGFS_FS && FIREWIRE && EXPERIMENTAL
> +	default n
> +	help
> +	  Say Y or M here to enable SCSI target functionality over FireWire.
> +	  This enables you to expose SCSI devices to other nodes on the FireWire
> +	  bus, for example hard disks. Similar to FireWire Target Disk mode on
> +	  older Apple computers.
> +
> +	  To compile this driver as a module, say M here: The module will be
> +	  called firewire-sbp-target.
> +

Hi Chris,

Just a minor Kconfig related item here.  You can go ahead and drop the
extra depends on TARGET_CORE && CONFIGFS_FS here, as
drivers/target/Kconfig is already handling the dependencies for these
two config options before including drivers/target/sbp/Kconfig.

Thanks!

--nab

