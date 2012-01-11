Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2AKOMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:12:06 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:38254 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2AKOMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:12:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20237.39051.575883.450826@quad.stoffel.home>
Date: Wed, 11 Jan 2012 09:11:23 -0500
From: "John Stoffel" <john@stoffel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
In-Reply-To: <CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
	<4F0B7D1F.7040802@gmail.com>
	<4F0BABE0.8080107@redhat.com>
	<CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
	<CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KOSAKI" == KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:

>> Also, I doubt current swap_cluster default is best value on nowadays.
KOSAKI> I meant, current average hdd spec is,
KOSAKI>  - average seek time: 8.5ms
KOSAKI>  - sequential access performance: about 60MB/sec

KOSAKI> so, we can eat free lunch up to 7MB ~= 60(MB/sec) * 1000 / 8.5(ms).

What if the disk is busy doing other writeout or readin during this
time?  You can't assume you have the full disk bandwidth available,
esp when you hit a swap storm like this.  

John
