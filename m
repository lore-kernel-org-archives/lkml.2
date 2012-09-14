Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2INQi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:38:27 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:54881 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2INQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:38:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
X-Fcc: ~/Mail/lkml
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields of
 the signal
In-Reply-To: Denys Vlasenko's message of  Friday, 14 September 2012 14:27:37 +0200 <CAK1hOcN79Gewb4x1W=WEDL6ESpcRQ0SD5mPzjRN6TY8jJvhCQw@mail.gmail.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
	<1347493124-10661-2-git-send-email-vda.linux@googlemail.com>
	<20120913153615.GB32128@redhat.com>
	<CAK1hOcN79Gewb4x1W=WEDL6ESpcRQ0SD5mPzjRN6TY8jJvhCQw@mail.gmail.com>
Emacs: the Swiss Army of Editors.
Message-Id: <20120914163820.B8FC92C0DB@topped-with-meat.com>
Date: Fri, 14 Sep 2012 09:38:20 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=4Q-4H7cYoKEA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=ZAWFwMYEd_IA:10 a=D0TYgUTFx-ByroDjQH0A:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other ELF notes have per-machine layouts too.  It's far more important to
reduce the total number of ways we have to represent the same information.
On a given machine, we already have a layout and we don't want another.
Debuggers and so forth already know how to handle the per-machine layouts.
The core file is just another way to get the same chunk of data you can get
from the live process.
