Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2G3Vtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:49:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53673 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2G3Vte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:49:34 -0400
Date: Mon, 30 Jul 2012 22:50:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Johansen <john.johansen@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: access current->comm directly
Message-ID: <20120730225037.4c8dd450@ultron>
In-Reply-To: <5016FADD.1030503@canonical.com>
References: <20120730165848.GA28288@www.outflux.net>
	<5016FADD.1030503@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012 14:21:33 -0700
John Johansen <john.johansen@canonical.com> wrote:

> On 07/30/2012 09:58 AM, Kees Cook wrote:
> > The core ptrace access checking routine already holds the task lock,
> > so there is no need to use get_task_comm() which just tries to take the
> > lock again. Drop its use and access current->comm directly.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> yep, looks good
> 
> Acked-by: John Johansen <john.johansen@canonical.com>


Code looks correct but having a weird cornercase direct reference is
asking for an accident later. For maintainability I'd rather see that as
__get_task_comm() or get_task_commu_unlocked() which does the job, deals
with all the edge cases and contains a WARN_ON check on the lock.

Alan
