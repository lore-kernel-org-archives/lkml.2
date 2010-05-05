Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0EEVhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:37:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab0EEVho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:37:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PdCTd5LPkuT+DkCZri1TbMvsvwwmUYxXlz+Zf+Sg1x++vuOaltxb2qFcZUU/APeqm
	uBxnkg1AlID+yVyIezgGg==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
References: <20100505202826.GB7450@linux.intel.com>
	 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
Date: Wed, 5 May 2010 14:37:39 -0700
Message-ID: <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: Brian Swetland <swetland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>> Oh, like tell the modem that user mode has handled the ring event and
>> its ok to un-block?
>
> No, that's not how it works.  It would go like this:
>
>        The modem IRQ handler queues its event to the input subsystem.
>        As it does so the input subsystem enables a suspend blocker,
>        causing the system to stay awake after the IRQ is done.
>
>        The user program enables its own suspend blocker before reading
>        the input queue.  When the queue is empty, the input subsystem
>        releases its suspend blocker.
>
>        When the user program finishes processing the event, it
>        releases its suspend blocker.  Now the system can go back to
>        sleep.
>
> At no point does the user program have to communicate anything to the
> modem driver, and at no point does it have to do anything out of the
> ordinary except to enable and disable a suspend blocker.

Exactly -- and you can use the same style of overlapping suspend
blockers with other drivers than input, if the input interface is not
suitable for the particular interaction.

Brian
