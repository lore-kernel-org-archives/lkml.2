Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2AXWuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:50:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2AXWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:50:38 -0500
Date: Tue, 24 Jan 2012 14:50:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Earl Chew <echew@ixiacom.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in
 procfs by kernel/sysctl.c
Message-Id: <20120124145037.f8223e37.akpm@linux-foundation.org>
In-Reply-To: <4F1D8F37.6020806@ixiacom.com>
References: <4F1C5995.3060806@ixiacom.com>
	<m1fwf6pjal.fsf@fess.ebiederm.org>
	<4F1D8180.9030509@ixiacom.com>
	<m1mx9enzr0.fsf@fess.ebiederm.org>
	<4F1D8F37.6020806@ixiacom.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 08:47:51 -0800
Earl Chew <echew@ixiacom.com> wrote:

> > Rereading different bytes of the integer multiple times when the integer
> > may be changing does not seem like a reasonable implementation.
> 
> Yes. I agree with you. I shall re-work the patch as per your suggestion.

Yes, this is a bug and procfs should support byte-at-a-time reading of these
strings.  And yes, they are strings!  Of digits.

We fixed an instance of this in procfs a while ago (maybe a year ago?).
But I forget where it was.  It is surprising that a bug of this nature
survived so long.

