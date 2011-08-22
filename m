Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1HVXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:21:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34203 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1HVXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:21:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 23 Aug 2011 01:21:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v3] firewire-sbp2: fix panic after rmmod with slow
 targets
Message-ID: <20110823012135.61aaf27d@stein>
In-Reply-To: <1314053771-29944-1-git-send-email-bootc@bootc.net>
References: <811318C8-1FD9-4E67-8346-13CFB69A0AF8@bootc.net>
	<1314053771-29944-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 22 Chris Boot wrote:
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1198,6 +1198,11 @@ static int sbp2_remove(struct device *dev)
>  {
>  	struct fw_unit *unit = fw_unit(dev);
>  	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
> +	struct sbp2_logical_unit *lu;
> +
> +	list_for_each_entry(lu, &tgt->lu_list, link) {
> +		cancel_delayed_work_sync(&lu->work);
> +	}
>  
>  	sbp2_target_put(tgt);
>  	return 0;

Thanks.  I reproduced the bug, applied your patch, and confirmed that the
patch fixes the bug.  Committed to linux1394-2.6.git but without the
curly braces.
-- 
Stefan Richter
-=====-==-== =--- =-===
http://arcgraph.de/sr/
