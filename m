Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0LOVkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:40:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab0LOVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:40:32 -0500
Message-ID: <4D093580.9000303@zytor.com>
Date: Wed, 15 Dec 2010 13:39:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home>	<20101215125626.25f7d648.akpm@linux-foundation.org>	<4D092D15.7030700@zytor.com> <AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
In-Reply-To: <AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 01:30 PM, Miguel Ojeda wrote:
> 
> In this case it this_cpu_*_test_bit() return an int, but they act as a
> bool and are used in if()s; where is the catch?
> 

If they aren't, and are stored in a variable for whatever reason, then
the || form will generate additional instructions to booleanize the
value for no good reason.

	-hpa
