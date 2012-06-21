Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab2FUOwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:52:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab2FUOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:52:03 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pvJ5EdTAJN3b61SmneoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340290321.27036.166.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Thu, 21 Jun 2012 10:52:01 -0400
In-Reply-To: <1340060577-9112-1-git-send-email-dhsharp@google.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 16:02 -0700, David Sharp wrote:
> This fixes a scenario in which trace_pipe_raw will return events with invalid
> timestamps when events are copied out one at a time (instead of swapping out
> the reader page with a spare page). In this scenario, ring_buffer_read_page()
> uses cpu_buffer->read_stamp to keep track of the time of the earliest event.
> However, cpu_buffer->read_stamp was not always updated. The only function that
> sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
> only by rb_get_reader_page(). rb_reset_reader_page() was not called when there
> is data immediately available on the page to read (read < rb_page_size()). This
> is the bug.

Hi David,

Thanks for the reminder, I'll be looking at it today.

Do you believe that this is an urgent fix and should be marked for
stable, or do you think it can wait till 3.6? If you think it should be
marked for stable, then it should be pushed for 3.5.

-- Steve


