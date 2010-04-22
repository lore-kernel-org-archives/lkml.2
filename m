Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0DVG0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:26:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47924 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0DVG0W convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:3:1>);
	Thu, 22 Apr 2010 02:26:22 -0400
Message-Id: <4BCFFA1B020000780005CBAE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 22 Apr 2010 07:26:19 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce and use percpu_inc()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin"  04/21/10 7:57 PM >>>
>On 04/21/2010 07:21 AM, Jan Beulich wrote:
>> ... generating slightly smaller code.
>> 
>> Signed-off-by: Jan Beulich 
>
>How much smaller?

The percpu_add(..., 1) -> percpu_inc() conversion is just a single
byte reduction (the immediate operand of the add); the other one
(where percpu_...() wasn't even used) is certainly a bigger win
(most of which obviously could also be achieved using percpu_add()).

>Keep in mind that although INC is smaller than ADD,
>the former has flag dependencies that the latter doesn't...

Wasn't that a problem just on Pentium4-s, which when I submitted
another related patch a couple of months back I was told would
not be a primary target anymore?

Jan

