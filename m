Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0GCBFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 21:05:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60249 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0GCBFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 21:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=YK8CQg/cDblwuQhykYHJPdVu1kg2GiIh0esofFiRH/SOF+xnJRIHqpzxoLN3pdbhdl
         wnx/nQZEtT3G8SU0Y9x7xbMSZ/6blutcFaoTjuMtUUUcRZrxCJxrvmU5AhYn1teLJ2c/
         TYLF9qx3N0rZLGQWkcm85E/7pbDnRre4ZtM2g=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCrfH69IJ_SQRkziFQJj8N3hTTPPHUvLv4JorV@mail.gmail.com>
References: <AANLkTikCrfH69IJ_SQRkziFQJj8N3hTTPPHUvLv4JorV@mail.gmail.com>
Date: Fri, 2 Jul 2010 19:05:19 -0600
Message-ID: <AANLkTikNTJSCFIoSevAh_49m0sQ7VROlSRq6Xosi7_yU@mail.gmail.com>
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

The specific function to look at is in entry_64.S sysret_check.  The
sequence goes;

swapgs
rex64 sysret

After swapgs the eflags in r11 do not match the actual flags passed.
The resume flag gets cleared when the sysret instruction completes,
and int 1 keeps firing on that processor until the stack runs out of
space.

Jeff
