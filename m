Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab0HDMyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:54:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:8560 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932619Ab0HDMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:54:13 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 08:54:13 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAD79WExLd/sX/2dsb2JhbAAHgw7PCZIIgSaDInME
X-IronPort-AV: E=Sophos;i="4.55,315,1278302400"; 
   d="scan'208";a="71618333"
Message-ID: <4C5960B0.7020003@teksavvy.com>
Date: Wed, 04 Aug 2010 08:44:32 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nigel Cunningham <nigel@tuxonice.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 used!
References: <4C58C528.4000606@tuxonice.net>
In-Reply-To: <4C58C528.4000606@tuxonice.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks to me like more and more things are using the block discard
functionality, and as predicted it is slowing things down enormously.

The problem is that we still only discard tiny bits (a single range still??)
per TRIM command, rather than batching larger ranges and larger numbers
of ranges into single TRIM commands.

That's a very poor implementation, especially when things start enabling
it by default.  Eg. the swap code, mke2fs, etc..

Ugh.
