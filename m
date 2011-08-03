Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1HCS11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:27:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1HCS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:27:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=n8XiV6i5V2O65hyNEryf64T/0aW/rw7X6Hek/9EjEDv5Bo58hO+yiY5PQD6+Vi0rX
	KberrLu+8vG7LQfoEQi1g==
MIME-Version: 1.0
In-Reply-To: <CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
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
	<CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
Date: Wed, 3 Aug 2011 11:27:16 -0700
Message-ID: <CAAuSN92zumHAOvthSYEQ5FqjpX_p2uw_WhDCb4ubHtEg9+vbpg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An update:

I realized that the timing function I was using was no good. On x86 it
will try to use the TSC but if it can't (which, as I understand, isn't
a very rare case), it will fall back on a jiffies-based solution. If
interrupts are disabled, time would appear to "stand still" and
lockups wouldn't be detected. So, looks like I have to nix this
particular patch and not change the hard lockup detection that much.

Meanwhile, I'm working on printing stack traces to a buffer/out to
file. I got some help and it looks like it's not that hard to do. I'll
send it when it's ready.
