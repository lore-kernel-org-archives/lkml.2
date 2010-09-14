Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0INWMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:12:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234Ab0INWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:12:45 -0400
Date: Tue, 14 Sep 2010 15:12:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH v2 03/10] RapidIO: Use stored ingress port number
 instead of register read
Message-Id: <20100914151219.5d92c6f9.akpm@linux-foundation.org>
In-Reply-To: <1284476363-1677-4-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
	<1284476363-1677-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 10:59:16 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> @@ -219,6 +219,7 @@ struct rio_net {
>  /**
>   * struct rio_switch - RIO switch info
>   * @node: Node in global list of switches
> + * @rdev: Associated RIO device structure
>   * @switchid: Switch ID that is unique across a network
>   * @hopcount: Hopcount to this switch
>   * @destid: Associated destid in the path
> @@ -234,6 +235,7 @@ struct rio_net {
>   */
>  struct rio_switch {
>  	struct list_head node;
> +	struct rio_dev *rdev;
>  	u16 switchid;
>  	u16 hopcount;
>  	u16 destid;

What is the locking for rdev?  In other patches I see pointer chases
with no obvious locking against concurrent changes?
