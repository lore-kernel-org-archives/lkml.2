Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2JSJi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:38:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:49722 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2JSJi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:38:56 -0400
Message-ID: <50811FA6.8000709@parallels.com>
Date: Fri, 19 Oct 2012 13:38:46 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: [PATCH v4] posix timers: allocate timer id per process
References: <20121019074912.10745.339.stgit@localhost.localdomain> <1350633401.2293.245.camel@edumazet-glaptop>
In-Reply-To: <1350633401.2293.245.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.10.2012 11:56, Eric Dumazet пишет:
> I wonder if some applications relied on our idr, assuming they would get
> low values for their timer id.
> (We could imagine some applications use a table indexed by the timer id)

Hmm.
Probably, this particular case can be optimised by tuning min_id to id of 
releasing timer (if id of this timer is less than current->signal min_id).
Does this approach solves the issue you mentioned above?

-- 
Best regards,
Stanislav Kinsbursky
