Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab0CTEpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:45:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab0CTEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:45:23 -0400
X-Authority-Analysis: v=1.0 c=1 a=EQ1AM5h6K_EA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=ZGjzRB5wRhgn8lB7pRkA:9 a=S8Y7fOx6VP7g1KfZfZsA:7 a=7XA4WsmGJpZxK7wdgrjr50F3pYYA:4 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] oprofile: remove double ring buffering
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com
In-Reply-To: <20100320000323.GA8411@basil.fritz.box>
References: <20100320000323.GA8411@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 00:45:20 -0400
Message-ID: <1269060320.28658.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 01:03 +0100, Andi Kleen wrote:
> [This is currently being tested if it fixes the excessive samples
> dropping I have been complaining about for some time. Still wanted
> to post the patch for review.]
> 
> commit 49e66e8ab54f1114237e6dc24dc32ac912870c41
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Fri Mar 19 21:03:48 2010 +0100
> 
>     oprofile: remove double ring buffering
>     
>     oprofile used a double buffer scheme for its cpu event buffer
>     to avoid races on reading with the old lock less ring buffer.

The old ring buffer was not lockless, hence the need for two ring
buffers because of NMIs. The new ring buffer is lockless.

>     
>     But that is obsolete now with the new ring buffer, so simply
>     use a single buffer. This greatly simplifies the code and avoids
>     some situations where samples could be dropped.
>     
>     Based on suggestions from Steven Rostedt

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>     
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 


