Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0INHuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:50:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab0INHt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:49:59 -0400
Message-ID: <4C8F2920.3000508@kernel.org>
Date: Tue, 14 Sep 2010 09:49:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: lockdep warning: events vs. bd_mutex
References: <201009122243.23765.arnd@arndb.de> <20100914160729.C9A1.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100914160729.C9A1.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Sep 2010 07:49:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/14/2010 09:27 AM, KOSAKI Motohiro wrote:
> lru_add_drain_all() wait system_wq.
> 
> Probably we have four choice.
>  1) simple revert buggy patch (I don't know how much serious original issue)
>  2) ata_scsi_dev_rescan() doesn't use system_wq
>  3) lru_add_drain_all() doesn't use system_wq
>  4) make IPI version lru_add_drain_all()
> 
> I'd like to hear Tejun's opinion.

Yeah, it was reported before.  The warning is bogus at this point.
The right thing to do would be improving lockdep annotation in
workqueue code but for now the easiest way out would be simply using
one of other system workqueues.  I'll look into it.

Thanks.

-- 
tejun
