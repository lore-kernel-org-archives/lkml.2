Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2AXT37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:29:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2AXT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:29:57 -0500
Message-ID: <4F1F06BF.3040605@gmail.com>
Date: Tue, 24 Jan 2012 14:30:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v3
References: <CABeCy1bgRe8=KKimBtB39F9KaJko=aD7xqYfAT0t6YcS6CMLZA@mail.gmail.com> <1327372455-1383-1-git-send-email-venki@google.com> <4F1F04E8.6000603@linux.vnet.ibm.com>
In-Reply-To: <4F1F04E8.6000603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I am not missing anything obvious, applying this patch can effectively
> convert the above code into an infinite loop, among other damages!
>
> I still feel it would be safer to edit set_cpu_possible() such that
> nr_possible_cpus is updated whenever cpu_possible_mask is altered.

Yup, I agree with you. The important thing is, even if we use set_cpu_possible(),
x86 performance doesn't drop. So, I don't understand why we need to take
current strategy.
