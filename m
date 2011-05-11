Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1EKPyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:54:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59522 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1EKPyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qgVGg/YXwmWPNRNyRvQAX9vo+HsD764ZKVTCvgWKBPARgsSxMsXS19zYD0wzSDtWB7
         pcVuWo+zB0gTH2wU13VdxWqhQ0s5/5gwXIfn/rkbGYnZcIvRIr7IuAQNnNQzZP/TJISB
         vQXGZBIs+gw7v3b4fqdxUV/U3m8R/7uGwRT/0=
MIME-Version: 1.0
In-Reply-To: <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
 <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com> <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
 <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 May 2011 10:47:19 -0400
Message-ID: <BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 05:19, Alessio Igor Bogani wrote:
>> name.  so rather than "__", use "+".
>
> Sorry I don't think that is a good choice from a long term point of
> view. What do you think to add MODULE_SYMBOL_PREFIX to section names
> instead? In this way symbol and section names should always be
> different also on symbol prefixed archs (which are blackfin and
> h8300).

that doesnt work.  it simply delays the problem to another set of
underscores.  so with that change, local_bh_enable/_local_bh_enable
work, but now send_remote_softirq/__send_remote_softirq fail:
  CC      kernel/softirq.o
nano /tmp/cconhYy1.s: Assembler messages:
/tmp/cconhYy1.s:3664: Error: symbol `___ksymtab___send_remote_softirq'
is already defined
make[1]: *** [kernel/softirq.o] Error 1

so any option that involves using underscores as the separator will
not work.  pick something else, like "+" or "." or ...  i dont see a
problem with using these.
-mike
