Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0D0UuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:50:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab0D0UuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:50:05 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=fwHPyVoetMsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=a9fD3qCDYAe8BfjaXDsA:9 a=d9rONzo4bTSrLcXmWG4A:7 a=zjyJBq_cwTOCjdccI2D-LyBTDX8A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: print sample std dev when function profiling
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
References: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 27 Apr 2010 16:50:02 -0400
Message-ID: <1272401402.9739.77.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 14:02 -0400, Chase Douglas wrote:

> +	/* Sample standard deviation (s^2) */
> +	if (rec->counter <= 1)
> +		stddev = 0;
> +	else {
> +		stddev = rec->time_squared - rec->counter * avg * avg;
> +		do_div(stddev, (rec->counter - 1) * 1000); /* ns^2 -> us^2 */

Shouldn't this be:

	do_div(stddev, (rec->counter - 1) * 1000000); ?

(x / 1000)^2 == x^2 / 1000^2


-- Steve

> +	}
> +


