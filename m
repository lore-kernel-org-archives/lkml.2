Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1CNTgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:36:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab1CNTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110314190446.GB21845@redhat.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com>
 <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com>
 <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com>
 <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com>
 <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com>
 <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190446.GB21845@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Mar 2011 12:35:52 -0700
Message-ID: <AANLkTi=YnG7tYCSrCPTNSQANOkD2MkP0tMjbOyZbx4NG@mail.gmail.com>
Subject: Re: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set
 TIF_MEMDIE if !p->mm
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>, David Rientjes <rientjes@google.com>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 12:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> oom_kill_process() simply sets TIF_MEMDIE and returns if PF_EXITING.
> This is very wrong by many reasons. In particular, this thread can
> be the dead group leader. Check p->mm != NULL.

Explain more, please. Maybe I'm missing some context because I wasn't
cc'd on the original thread, but PF_EXITING gets set by exit_signal(),
and exit_mm() is called almost immediately afterwards which will set
p->mm to NULL.

So afaik, this will basically just remove the whole point of the code
entirely - so why not remove it then?

The combination of testing PF_EXITING and p->mm just doesn't seem to
make any sense.

                      Linus
