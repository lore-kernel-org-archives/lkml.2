Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1HAULg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:11:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HAULb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:11:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=BWqy5xPl+JqHwnQq0vn38k93C8YKCMNfCYuKo9lIJXILqvD9TMAq0Hg3xzEGvixb8
	pslmNQkin6AmsT1icvxNw==
MIME-Version: 1.0
In-Reply-To: <20110801192407.GE2581@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
	<20110722195340.GF3765@redhat.com>
	<CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
	<20110725124451.GA2866@redhat.com>
	<CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
	<20110729205538.GD14343@redhat.com>
	<CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
	<20110801125234.GE14343@redhat.com>
	<CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
	<20110801192407.GE2581@redhat.com>
Date: Mon, 1 Aug 2011 13:11:27 -0700
Message-ID: <CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 12:24 PM, Don Zickus <dzickus@redhat.com> wrote:
> One idea I thought of to workaround this is to save the timestamp and the
> watchdog bool and restore after the stack dump.  It's a cheap hack and I
> am not to sure about the locking as it might race with
> touch_nmi_watchdog().  But it gives you an idea what I was thinking.
Yes, I see. Is the hackiness of it okay?

> Being in the nmi context, no one can normally touch these variables,
> except for another cpu using touch_nmi_watchdog() (or watchdog_enable()
> but that should never race in these scenarios).
Well, the soft lockup stuff is not a NMI but just a regular interrupt,
right? Is that also okay?
