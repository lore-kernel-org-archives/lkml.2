Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1EXTEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:04:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932975Ab1EXTEI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1306262259-7285-8-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org> <1306262259-7285-8-git-send-email-tj@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 12:03:16 -0700
Message-ID: <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com>
Subject: Re: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:37 AM, Tejun Heo <tj@kernel.org> wrote:
>
> +               wake_up_bit(&task->jobctl, ilog2(JOBCTL_TRAPPING));

Why do people do this *SHIT*?

Stop it.

If you need the bit number, then define the damn thing in terms of bit
numbers! Do

  #define JOBCTL_TRAPPING_BIT xxx
  #define JOBCTL_TRAPPING (1u << JOBCTL_TRAPPING_BIT)

but never ever do that stupid ilog2() thing. Every time I see it I go
"ok, that's just total crap".

Don't do it.

                      Linus
