Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1HFPXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:23:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46787 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HFPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:23:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110805205921.909038487@goodmis.org>
References: <20110805205921.909038487@goodmis.org>
Date: Sat, 6 Aug 2011 11:23:52 -0400
X-Google-Sender-Auth: 7olmsM8STdbicZsbtsipd1Mdyx8
Message-ID: <CADkLE3Xy--nuoy41VUUN7Mi9ZrkBkagw-ew4AMxCeHWAQR2u0Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Colin Walters <walters@verbum.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 4:59 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Note, because perf installs in the user's ~/bin and I did not want to
> make it a requirement to add ~/bin to LD_LIBRARY_PATH, I kept the
> library as a .a that is linked directly into perf.

Note you can add an rpath to avoid having to modify LD_LIBRARY_PATH;
rpath is just better for this kind of thing.  As a general rule of
thumb, if you're installing somewhere outside of the target system's
/etc/ld.so.conf, add an rpath.  And for this purpose ignore e.g.
Fedora's broken tendency to put private libraries in
/etc/ld.so.conf.d.
