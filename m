Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab0GHRsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:48:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0GHRs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:48:28 -0400
Subject: Re: [PATCH] Add trace event for munmap
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric B Munson <ebmunson@us.ibm.com>, Eric B Munson <emunson@mgebm.net>,
       akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       anton@samba.org
In-Reply-To: <20100708173515.GA11652@infradead.org>
References: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
	 <1278598955.1900.152.camel@laptop> <20100708144407.GA8141@us.ibm.com>
	 <20100708173515.GA11652@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 19:48:08 +0200
Message-ID: <1278611288.1900.164.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 13:35 -0400, Christoph Hellwig wrote:

> What kind of infrastructure is perf using for recording
> mmap()/mremap()/brk() information?

A direct hook into mmap_region(), see perf_event_mmap().

We used to only track VM_EXEC regions, but these days we can also track
data regions (although it wouldn't track mremap and brk I think).

We need the VM_EXEC maps to make sense of the instruction pointer
samples.

Eric recently added support for !VM_EXEC mmap() in order to interpret
linear addresses provided by things like the software pagefault events
and certain powerpc hardware events.


