Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2BOCeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:34:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58733 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2BOCeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:34:09 -0500
Date: Tue, 14 Feb 2012 18:37:05 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephane Eranian <eranian@google.com>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        gleb@redhat.com, wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, paulus@samba.org, emunson@mgebm.net,
        imunsie@au1.ibm.com, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
Message-ID: <20120215023705.GA13042@us.ibm.com>
References: <20120126160319.GA5655@quad>
 <20120208223250.282861cb@kryten>
 <CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
 <20120210031930.GA28023@us.ibm.com>
 <1328854519.3019.3.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328854519.3019.3.camel@pasglop>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021502-6148-0000-0000-00000372F80A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt [benh@kernel.crashing.org] wrote:
| On Thu, 2012-02-09 at 19:19 -0800, Sukadev Bhattiprolu wrote:
| > Stephane Eranian [eranian@google.com] wrote:
| > | On Wed, Feb 8, 2012 at 12:32 PM, Anton Blanchard <anton@samba.org> wrote:
| > | >
| > | > Hi,
| > | >
| > | > On Thu, 26 Jan 2012 17:03:19 +0100
| The powerpc .git tree is not useful at this point, I haven't opened
| powerpc -next yet so it's just all old stale stuff. Please work with
| upstream always unless you have a very good reason to use my tree. It's
| really only meant as a conduit between me and Linus or for -next.

Ok.

I tried this on current mainline (commit 13d261932) which now includes both
of Stephane's patches and repeated the nooploop test.

The problem still exists - the number of events reported on Power is far
fewer than without the patches.

Aggregated stats:
           TOTAL events:         78
            MMAP events:         47
            COMM events:          2
            EXIT events:          2
          SAMPLE events:         27
cycles stats:
           TOTAL events:         21
            MMAP events:          4
            COMM events:          1
            EXIT events:          2
          SAMPLE events:         14
cycles stats:
           TOTAL events:         13
          SAMPLE events:         13

Sukadev

