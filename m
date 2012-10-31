Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935641Ab2JaOJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:09:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:14428 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305Ab2JaOJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,687,1344236400"; 
   d="scan'208";a="242413785"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: anish kumar <anish198519851985@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>
Subject: RE: [PATCH] [RFC]IRQ CORE: irq_work_queue function return value not
 used.
Thread-Topic: [PATCH] [RFC]IRQ CORE: irq_work_queue function return value
 not used.
Thread-Index: AQHNt3Bx5Y0zd+0Pe0mCQZXo+N8BQZfTcz7w
Date: Wed, 31 Oct 2012 14:09:07 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD2452296C@BGSMSX102.gar.corp.intel.com>
References: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
In-Reply-To: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -bool irq_work_queue(struct irq_work *work)
> +void irq_work_queue(struct irq_work *work)
>  {
> -	if (!irq_work_claim(work)) {
> -		/*
> -		 * Already enqueued, can't do!
> -		 */
> -		return false;
> -	}
> -
> +	/*
> +	 * This function either will claim the entry to queue
> +	 * the work or if the work is already queued and is in
> +	 * pending state then it will simply return.
> +	 */
> +	irq_work_claim(work)
>  	__irq_work_queue(work);
>  	return true;
>  }
You can remove the last return statement.

Thanks,
Ram
