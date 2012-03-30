Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab2C3Nqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:46:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54829 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2C3Nqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F75A2AA.4010604@hitachi.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
 <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
 <1333065559.2960.8.camel@laptop> <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
 <1333068279.2960.20.camel@laptop> <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
 <4F75A2AA.4010604@hitachi.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 30 Mar 2012 09:46:10 -0400
Message-ID: <CAOPLpQdgU1BVRrpN33vteyg=vRjMqjBYzCiHG2xx7YVqeWRejQ@mail.gmail.com>
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 08:10, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Right, almost all function arguments are passed by register on x86-64.
> Hmm, this might be useful because it can trace function register-arguments
> in user-space applications... even though it causes interruption on every
> sampling calls...

You only have to do this for the first call frame and only if the
breakpoint is at the first instruction of the function.

Otherwise the register content can of course already be destroyed.

Given this, is it really worth it?  For instance, for any backtrace
from the breakpoint in kernel there is nothing at all you gain from
recording the register content.
