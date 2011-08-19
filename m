Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1HSUva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:51:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33666 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1HSUv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:51:27 -0400
MIME-Version: 1.0
In-Reply-To: <1313778007.15704.106.camel@gandalf.stny.rr.com>
References: <1313539478-30303-1-git-send-email-kjwinchester@gmail.com>
	<1313778007.15704.106.camel@gandalf.stny.rr.com>
Date: Fri, 19 Aug 2011 17:51:26 -0300
Message-ID: <CAELBVzBBBc7HCPbE+orLD-tE1nBvGM2BBv+ietzoJJi-ubPdCQ@mail.gmail.com>
Subject: Re: [PATCH] x86: jump_label: arch_jump_label_text_poke_early: add
 missing __init
From: Kevin Winchester <kjwinchester@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: jbaron@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2011 15:20, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-08-16 at 21:04 -0300, Kevin Winchester wrote:
>> arch_jump_label_text_poke_early calls text_poke_early, which is
>> an __init function.  Thus arch_jump_label_text_poke_early should
>> be the same.
>
> but text_poke_early is not __init but instead __init_or_module. Your
> patch just caused this bug:
>

Sorry about that.  I have:

# CONFIG_MODULES is not set

which makes __init_or_module equivalent to __init for me.  Thus the
patch was fine for my case, but I expect your modification is the
right thing to do overall.

-- 
Kevin Winchester
