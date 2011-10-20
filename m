Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1JTIO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:14:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36935 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab1JTIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:14:58 -0400
Date: Thu, 20 Oct 2011 12:14:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, anton@samba.org, daahern@cisco.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
Message-ID: <20111020081451.GC14464@moon>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:54:40AM +0300, Pekka Enberg wrote:
...
> 
> Is there some specified maximum length for symbols (e.g. in ELF spec)?
> I'm OK with the patch but I'd prefer we didn't bump up the number
> blindly there's something "official" number we can use.
> 
>                         Pekka

Elf restricts offsets in string table by 4 bytes, so probably the option
is to have complete .strtab being read somewhere and use indices when needed.
(note I didn't check where perf tool need those names).

	Cyrill
