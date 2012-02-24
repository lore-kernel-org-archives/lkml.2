Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2BXOQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:16:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62664 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2BXOQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:16:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rabin.vincent@gmail.com designates 10.50.236.34 as permitted sender) smtp.mail=rabin.vincent@gmail.com; dkim=pass header.i=rabin.vincent@gmail.com
MIME-Version: 1.0
In-Reply-To: <2f2b55523b707d514a15d822ff812cfae654510a.1330079584.git.viresh.kumar@st.com>
References: <2f2b55523b707d514a15d822ff812cfae654510a.1330079584.git.viresh.kumar@st.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 24 Feb 2012 19:45:32 +0530
X-Google-Sender-Auth: gNbQKy7J40yRix0kTN7tuGGPfNs
Message-ID: <CAH+eYFAEnWdvzojefix_iAefUK3BnLQNcwP2xY0vLHf5RLj5eg@mail.gmail.com>
Subject: Re: [PATCH] gpio/gpio-stmpe: Fix the value returned by _get_value routine
To: Viresh Kumar <viresh.kumar@st.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        salvatore.dedominicis@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 16:04, Viresh Kumar <viresh.kumar@st.com> wrote:
> The present _get_value routine returns the contents of the GPIO
> Monitor Pin Status Register(GPMR) starting from the bit whose value
> is requested to BIT 0.
>
> For e.g. if we request the value of GPIO 6 in the earlier
> implementation the value returned is:
>
>        BIT6 to BIT0
>
> whereas it should just return BIT6.

The current implementation just returns (ret & mask) where mask
would have only BIT6 set, so how can it return "BIT6 to BIT0" ?
