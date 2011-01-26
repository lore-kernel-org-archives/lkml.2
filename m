Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1AZGU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:20:27 -0500
Received: from lo.gmane.org ([80.91.229.12]:38392 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1AZGU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:20:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: Recursive deactivation of local bottom halves
Date: Wed, 26 Jan 2011 06:20:10 +0000 (UTC)
Message-ID: <ihoeep$kmn$4@dough.gmane.org>
References: <201101251405.18157.emil.langrock@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 14:05:14 +0100, Emil Langrock wrote:
...
> ...
> local_bh_disable();
> ....
> 	local_bh_disable();
> 	...
> 	local_bh_enable();
> ....
> local_bh_enable();
> ....
...
> 
> Can somebody tell me if that is legal or not (on smp and uniprocessor)?
> And maybe can show me the related source code why is it may or may not
> be legal?
> 

>From what you show to us, it is legal, as long as local_bh_disable()/
local_bh_enable() are always paired, it is fine to call them nestedly.

