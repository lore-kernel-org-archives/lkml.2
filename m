Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0DINc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:32:29 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:34687 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0DINc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:32:26 -0400
Message-ID: <4BBF2C5E.4060801@lumino.de>
Date: Fri, 09 Apr 2010 15:32:14 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de>	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>	<4BBF0784.2060002@lumino.de>	<20100409125426.5bc200da@lxorguk.ukuu.org.uk>	<4BBF2351.3040506@lumino.de> <20100409141518.0dbe7050@lxorguk.ukuu.org.uk>
In-Reply-To: <20100409141518.0dbe7050@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:15 PM, Alan Cox wrote:
> Lamport's Bakery
Hmm. The code implements the lock as a busy spinning wait. This of
course is not possible in real world, as the thread that has the lock
will not get any CPU time (e.g. in a non-SMP system).

I understand that the main purpose of the FUTEX Kernel call(s) is doing
a not-busy wait and having the "unlock" code wake the (next) waiting thread.

I did implement something like this in my testing program: enhanced by a
sleep to allow for the thread that has the lock to proceed it's work,
but this of course is not fast at all, as a short sleep() produces too
much CPU load and a long sleep produces too much latency.

So maybe this algorithm can be used instead of the hardware stuff I
suggested but it would need a FUTEX-like Kernel part, too.

-Michael
