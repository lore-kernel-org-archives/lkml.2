Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab1CDTCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:02:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:50668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918Ab1CDTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:02:14 -0500
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
In-Reply-To: <1299084001-3916-2-git-send-email-kirill@shutemov.name>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
	 <1299084001-3916-2-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 20:03:42 +0100
Message-ID: <1299265422.22521.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 18:40 +0200, Kirill A. Shutsemov wrote:
> -       if (ret < current->timer_slack_ns)
> -               return current->timer_slack_ns;
> -       return ret;
> +       return clamp(__estimate_accuracy(&now),
> +                       get_task_timer_slack(current), LONG_MAX);

That actually makes the code worse, how about:

  min(__estimate_accuracy(), get_task_timer_slack()) ?



