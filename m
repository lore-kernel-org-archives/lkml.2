Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0GBWSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 18:18:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41333 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0GBWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 18:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xkp5P/6Jb4E4KoyRI05ZRmQtmoKINrrmSroXxXW86uAaPbbAmBmqxgLaSyZ1Ib9vfL
         aNMwda1WmHegiIlhJjfVJLbNDQEjxBHM3iQOE/R/TVjEpFk7dQizohzLnwjkv02pGf7r
         y/2HavT9DW4zCNAExVcZ4BExUo0JT6IvWCUrg=
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 16:18:05 -0600
Message-ID: <AANLkTikCrfH69IJ_SQRkziFQJj8N3hTTPPHUvLv4JorV@mail.gmail.com>
Subject: 2.6.34 rex64 sysret instruction setup not preserving flags (r11 
	contents and eflags do not match)
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an AMD64 based system executing int 1 exceptions across a rex64
sysret, if the debugger sets the trap flag, r11 which holds the eflags
values for the
sysret return from syscall, the flags do not appear to get set
resutling in the int exception nesting by calling sysret over and over
again until the kernel stack
runs off the end.  Looks like the resume did not get set on this instruction.

sysret on AMD requires the flags be saved into r11 and what I am
seeing is the flags not matching what has been set in the pt_regs
struct.

Jeff
