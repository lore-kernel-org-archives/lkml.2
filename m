Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab0HDXjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:39:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759528Ab0HDXjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:39:31 -0400
Date: Wed, 4 Aug 2010 16:38:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv3 16/16] pps: add parallel port PPS signal generator
Message-Id: <20100804163804.fce2ffd6.akpm@linux-foundation.org>
In-Reply-To: <6015d3803449935de8f1425efdfae4736d775047.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<6015d3803449935de8f1425efdfae4736d775047.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Aug 2010 01:06:53 +0400
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> Add PPS signal generator which utilizes STROBE pin of a parallel port to
> send PPS signals. It uses parport abstraction layer and hrtimers to
> precisely control the signal.
> 
> ..
>
> +static unsigned int send_delay = 30000;
> +MODULE_PARM_DESC(delay,
> +	"Delay between setting and dropping the signal (ns)");
> +module_param_named(delay, send_delay, uint, 0);

This code doesn't look easy to configure and use.  For example, if some
random person tries to get it going, how does he even know that this
module parameter exists, let alone how to use it?

Please review Documentation/pps/pps.txt and check that it accurately
and completely describes how to use the pps code after your changes,
thanks.

