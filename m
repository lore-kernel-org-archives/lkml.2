Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0FQXR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:17:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760881Ab0FQXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:17:28 -0400
Date: Thu, 17 Jun 2010 16:16:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Daniel Walker <dwalker@codeaurora.org>, Tejun Heo <tj@kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
       arjan@linux.intel.com, johannes@sipsolutions.net, oleg@redhat.com,
       axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100617161619.d3ebd73d.akpm@linux-foundation.org>
In-Reply-To: <1276776066.2461.15.camel@localhost>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 08:01:06 -0400
Andy Walls <awalls@md.metrocast.net> wrote:

> I'm going to agree with Tejun, that tweaking worker thread priorities
> seems like an odd thing, since they are meant to handle deferable
> actions - things that can be put off until later.

Disagree.  If you're in an interrupt handler and have some work which
you want done in process context and you want it done RIGHT NOW then
handing that work off to a realtime-policy worker thread is a fine way of
doing that.


