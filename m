Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2HOSkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:40:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47568 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HOSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:40:00 -0400
Date: Wed, 15 Aug 2012 19:44:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120815194426.52fd7936@pyramind.ukuu.org.uk>
In-Reply-To: <CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
References: <20120726134748.GA20605@localhost>
	<CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	<20120810015222.GA19286@localhost>
	<CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
	<20120815030110.GA24836@localhost>
	<CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
	<20120815130159.GA3221@redhat.com>
	<1345041021.31459.88.camel@twins>
	<20120815175651.GA17814@redhat.com>
	<CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It sounds like get_task_comm shouldn't have locking at all then? It
> should just do a length-limited copy and make sure there is a trailing
> 0-byte?

It has locking so that it has a consistent state and more importantly it
has an accessor function

Directly accessing it is asking for bugs in future. If you hold the
needed lock then just add an

__get_task_comm() 

method that asserts the lock is held. That way the rest of the behaviour
remains properly encapsulated for when someone changes it.

Alan
