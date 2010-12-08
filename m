Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0LHTG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:06:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:48981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab0LHTGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:06:55 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <4CFFD1C2.1080108@kernel.org>
References: <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	 <1291764620.2032.1293.camel@laptop>  <20101208140103.GM21786@redhat.com>
	 <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop>
	 <4CFFD1C2.1080108@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 20:06:36 +0100
Message-ID: <1291835196.28378.145.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 10:43 -0800, Yinghai Lu wrote:
> can you add sth force_... in command line to take over ownership of
> perf from BIOS or previous kernel ?

The problem is, you cannot steal the thing from the BIOS, you'll trample
on its settings and the next time it runs it will simply re-instate it.

And aside from probing the EN bit on boot there is no way of determining
this.

So forcing the state might get you an ill-functioning system.

> then still can use perf etc after we kexec from RHEL or SLES kernel to
> later kernel ( from 2.6.37)

I'm not sure why people would do that, but yeah I guess we can do
something like that.
