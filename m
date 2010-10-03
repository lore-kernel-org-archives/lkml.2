Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0JCSPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:15:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64975 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0JCSPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WXHm9LqLqhQSWLUxNj8fo+mJjjaJ71Q6nUnXgsIXZes1Fwyo+JRlXosyERsZ/ykJAH
         ITDtLjM0AWvp8HY1VQvjfVA1yvhEmqRSlkH2jTriy+bi3C8pQKBZIL0+exopzRNGoaT+
         airncLhbiivCHigcC4aNlZrV+1Dg0uOU2D0mA=
MIME-Version: 1.0
In-Reply-To: <1285697432-29244-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285697432-29244-1-git-send-email-ddaney@caviumnetworks.com>
Date: Sun, 3 Oct 2010 23:45:37 +0530
X-Google-Sender-Auth: kiWWaVS6GTLpwKbUcfxjlYqiG-4
Message-ID: <AANLkTimEJQE3i9Wa1X=Rkw1goJA9c5Sso-iWV=hLG6KF@mail.gmail.com>
Subject: Re: [PATCH] jump label: Add MIPS support.
From: Rabin Vincent <rabin@rab.in>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, jbaron@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 11:40 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> +void arch_jump_label_text_poke_early(jump_label_t addr)
> +{
> +       union mips_instruction *insn_p =
> +               (union mips_instruction *)(unsigned long)addr;
> +
> +       insn_p->word = 0; /* nop */
> +       flush_icache_range((unsigned long)insn_p,
> +                          (unsigned long)insn_p + sizeof(*insn_p));
> +}

Can't this function be a no-op on MIPS?  This seems to be
used on x86 to patch in the optimal nop instruction, but
on MIPS the optimal/only nop instruction should already
be in place at build time.  Same thing for the SPARC
implementation.

Rabin
