Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1F3N13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:27:29 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:46827 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1F3N1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:27:22 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: possible bridge regression in "bridge: implement [add/del]_slave ops"?
Date: Thu, 30 Jun 2011 15:27:19 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201106301033.23997.alexander.stein@systec-electronic.com>
In-Reply-To: <201106301033.23997.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301527.19539.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011 10:33:23 Alexander Stein wrote:
> BTW: I noticed that in 2.6.39.2 independently from this patch revert this
> bridge didn't show up RUNNING ifconfg. Is this intended? Another bridge I
> have, which doesn't use (R)STP, is shown as RUNNING like before.

This change was caused by commit 1faa4356a3bd89ea11fb92752d897cff3a20ec0e 
"bridge: control carrier based on ports online". It prevents the bridge from 
actually receiving/sending packets. Reverting restores the old behavior.
