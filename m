Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2AIIz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:55:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2AIIz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:55:28 -0500
Message-ID: <1326099318.2442.39.camel@twins>
Subject: Re: [PATCH] perf_events: proposed fix for broken intr throttling
 (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, mingo@elte.hu,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
Date: Mon, 09 Jan 2012 09:55:18 +0100
In-Reply-To: <CABPqkBSmDHHJsSQo8hhe0a9zxr+YX1yWNr3hZoWEU-OShu7=wA@mail.gmail.com>
References: <20120106181912.GA5564@quad> <1325955818.2442.29.camel@twins>
	 <CABPqkBSmDHHJsSQo8hhe0a9zxr+YX1yWNr3hZoWEU-OShu7=wA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-08 at 00:11 +0100, Stephane Eranian wrote:
> I'll look into that one. But at first glance, it does not address the issue
> of adjusting the period at each timer tick. Only multiplexing (rotation) should
> happen at the multiplier rate.

Correct, it only pokes at the throttle stuff. For the freq stuff we can
remain using the nr_freq count to see if we need the iteration.

But yeah, I think that separation you did makes sense.
