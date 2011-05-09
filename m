Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1EIK4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:56:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60148 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1EIK4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oawBKcsPJ+0OUZMRnL0gsnlkv6FwgAdrG/g7p9mxFN/ANpr+rnt6Tniup/GiGtN8Mi
         7IRG9EtnRkCWDvhjauGK+AV9Wf4PJ8fUql2Ah4+sxOnw44mP9EWg495QaxpyCYaJvE3o
         Cl50mACoBlJpP6eUnWvdPVobclai/sz38CtpM=
MIME-Version: 1.0
In-Reply-To: <20110509100931.GH1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org> <201105082358.20159.vda.linux@googlemail.com>
 <20110509100931.GH1661@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 9 May 2011 12:55:41 +0200
Message-ID: <BANLkTims2K67JC48Lkz=nLjn18-yPAYX-g@mail.gmail.com>
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 12:09 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sun, May 08, 2011 at 11:58:20PM +0200, Denys Vlasenko wrote:
>> Are rules for PTRACE_INTERRUPT the same? That is, what happens
>> if a different trap is taken?
>
> Oh, PTRACE_INTERRUPT is different.  If it's scheduled, it will
> eventually happen.  Other traps may happen before but INTERRUPT trap
> will take place before control is returned to userland.
>
>> Can you add API notes in the header, above corresponding defines? -
>>
>> --- a/include/linux/ptrace.h
>> +++ b/include/linux/ptrace.h
>> @@ -48,6 +48,7 @@
>>  #define PTRACE_SETREGSET       0x4205
>>
>> <============================================ ADD COMMENT HERE
>>  #define PTRACE_SEIZE           0x4206
>> <============================================ ADD COMMENT HERE
>> +#define PTRACE_INTERRUPT       0x4207
>>
>>
>> They will be much more visible and up-to-date there than in Documentation,
>> git logs etc...
>
> Hmmm... I was thinking about writing a proper ptrace API doc with
> example programs under Documentation/.  It's userland visible API so
> it shouldn't change all that much

My motivation is mostly to prevent or make it less likely for someone
who will hack on this code in the future to misunderstand semantics
of these ops. A hacker changing PTRACE_INTERRUPT-related code
is much more likely to notice a comment above PTRACE_INTERRUPT
definition than a file buried in Documentation/.

> and the amount of necessary
> documentation would be too much for comments.

Yes, if you'd try to put there a comprehensive doc.
The comment I envision is short, yet captures the most important
traits of the operation. For example:

/* After PTRACE_SEIZE, tracee will trap - once. It may be a signal delivery
 * or group stop, if one is already pending; otherwise,
 * a SIGTRAP | (PTRACE_EVENT_INTERRUPT << 8) trap is taken.
 * A trap will happen in finite amount of userland time.
 */
#define PTRACE_SEIZE           0x4206

-- 
vda
