Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0JYUPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:15:53 -0400
Received: from mail80c7.megamailservers.com ([69.49.98.180]:37410 "EHLO
	mail80c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757200Ab0JYUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:15:52 -0400
X-Authenticated-User: paulkf.microgate.com
Message-ID: <4CC5F478.40109@microgate.com>
Date: Mon, 25 Oct 2010 15:19:52 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] n_hdlc fix read and write locking
References: <1288030959.19909.28.camel@x2.microgate.com> <20101025130502.77685ac1.akpm@linux-foundation.org>
In-Reply-To: <20101025130502.77685ac1.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=3MDj9jfwMdIPmqiqQWLsSeuCDRApQy4LYeV7Bir5PyU= c=1 sm=1
		a=IdFlvoSyVXkA:10 a=8nJEP1OIZ-IA:10 a=IzlbXlj4Xhqf7W9accngow==:17
		a=ijWuk3ZyAAAA:8 a=0fOZRVO8yji8SAe3r2IA:9 a=0-i-obMJ4xJuLb-S0edcY7CzjrEA:4
		a=wPNLvfGTeEIA:10 a=vr08yV7lTEoA:10 a=M2bT9TDNGrIA:10 a=aUOK4Wo89ZcA:10
		a=UEqaQSiRgn0A:10 a=oBK5D_4X9z4A:10 a=NGcOuUOJdRAA:10 a=xBexlFGNibAA:10
		a=IzlbXlj4Xhqf7W9accngow==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 2:05 PM, Andrew Morton wrote:
> And a signed-off-by:, please.

OK

> It's not a bug afaict, but beware that a copy_to_user() will
> unconditionally flip this task back into TASK_RUNNING state if it takes
> a pagefault.  This means that the below schedule() will fall straight
> through.  It looks like the code will handle this correctly?  If so,
> it's just a little suboptimal.

copy_to_user is only called when data is available to
complete the read and break terminates the loop without
calling schedule().

>> +	set_current_state(TASK_RUNNING);
> 
> We normally use __set_current_state() here - it saves a few cycles.

I'll change it to __set_current_state() and resubmit.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -6h)
www.microgate.com
