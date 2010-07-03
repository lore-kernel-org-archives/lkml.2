Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0GCE6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 00:58:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63274 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0GCE6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 00:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lIgeYmZ0Mz4aMYvz4WnFYiXYOtx/TgoqX39IF1X1a/p0e1kJuM+syzMAfs2ecjI5Q0
         uiyIe6ZlXJ5xS3vTh8siQ6bwRPbIUhwyCGALm4gQZCKx1WXfYaz5Ar7laaiU2sgGSyk1
         Q8c1QbkId1H/K3J9+GqrlJbVAmwZlseVssDbE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCrfH69IJ_SQRkziFQJj8N3hTTPPHUvLv4JorV@mail.gmail.com>
References: <AANLkTikCrfH69IJ_SQRkziFQJj8N3hTTPPHUvLv4JorV@mail.gmail.com>
Date: Fri, 2 Jul 2010 22:58:52 -0600
Message-ID: <AANLkTilUHCqbHB0YA5swqhzixXNW3gFpiTcl0z_5lOBe@mail.gmail.com>
Subject: Re: 2.6.34 rex64 sysret instruction setup not preserving flags (r11 
	contents and eflags do not match)
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 4:18 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> On an AMD64 based system executing int 1 exceptions across a rex64
> sysret, if the debugger sets the trap flag, r11 which holds the eflags
> values for the
> sysret return from syscall, the flags do not appear to get set
> resutling in the int exception nesting by calling sysret over and over
> again until the kernel stack
> runs off the end.  Looks like the resume did not get set on this instruction.
>
> sysret on AMD requires the flags be saved into r11 and what I am
> seeing is the flags not matching what has been set in the pt_regs
> struct.
>
> Jeff
>

For some reason, zeroing the DR6 register before calling notify_die
makes this problem go away.

Jeff
