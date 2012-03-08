Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab2CHWzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:55:09 -0500
Received: from plane.gmane.org ([80.91.229.3]:55514 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828Ab2CHWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:55:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Christian =?utf-8?b?S8O2bmln?= <deathsimple@vodafone.de>
Subject: Re: [PATCH] dvb-core: fix =?utf-8?b?RFZCRkVfQUxHT19IVw==?= retune bug
Date: Thu, 8 Mar 2012 22:26:54 +0000 (UTC)
Message-ID: <loom.20120308T231756-162@post.gmane.org>
References: <4F304CAD.5080700@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.60.210.110 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:10.0.2) Gecko/20100101 Firefox/10.0.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott <simon <at> fire.lp0.eu> writes:

> 
> Commit 7e07222 breaks DVBFE_ALGO_HW tuning after a retune is requested,
> which causes bad tuning on my TBS 6920.
> 
> [    0.769091] pci 0000:06:00.0: [14f1:8852] type 0 class 0x000400
> [   19.733530] CORE cx23885[0]: subsystem: 6920:8888, board: TurboSight TBS
6920 [card=14,autodetected]
> [  762.824912] cx24116_load_firmware: FW version 1.23.86.1
> 
> 7e0722215a510921cbb73ab4c37477d4dcb91bf8 [media] dvb-core: Don't pass DVBv3
parameters on tune() fops
> 
> Although re_tune is set to true when FESTATE_RETUNE occurs, it is never
> set back to false which the old code used to do when !FESTATE_RETUNE.
> 
> This patch sets re_tune to false if !(state & FESTATE_RETUNE).
> 
[snip]
> 
> Signed-off-by: Simon Arlott <simon <at> fire.lp0.eu>

Please make sure that this patch is pushed upstream, since the patch who
introduced the bug is already in 3.3-rc6 but not this fix. Otherwise:

Tested by: Christian König <deathsimple@vodafone.de




