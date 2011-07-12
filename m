Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1GLSCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:02:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58117 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1GLSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <1310454020-15426-1-git-send-email-abogani@kernel.org>
References: <CACqU3MW=VUn64nsSA2V_eXEfEjv6xmB9yBWL8rYynH1wkHcOgw@mail.gmail.com>
	<1310454020-15426-1-git-send-email-abogani@kernel.org>
Date: Tue, 12 Jul 2011 14:02:37 -0400
Message-ID: <CAFziu1HvspbMj8LRLHd2w9vcVq_mGCL3pCOwLaduKQ4nt8+Utg@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V2
From: Anders Kaseorg <andersk@ksplice.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:00, Alessio Igor Bogani <abogani@kernel.org> wrote:
> +#define SEC_NAME_MATCH(name, str) (strncmp(name, str, strlen(str) - 1) == 0)

Surely you meant strlen() or sizeof() - 1, not strlen() - 1?

> +       if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)

Same strncmp pattern here.  BTW, your macro is the strstarts()
function in include/linux/string.h.

Anders
