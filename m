Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0E3Vvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 17:51:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab0E3Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 17:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lGn/0bqrtdeN9bJ1Bt5mR8/dbI9bJAWRAbw/4Ac0D7lxeL7/yrLllhMpDmC1CoUBPL
         ruP6Mx1J+fZhblRPHYpPWOyqArLvddK4+3Ab9kv62Nx7bBwlgc9YsdBANK5TCf123J3E
         VNsb9rtYb/m6VRq9q6AO3r0wxPNHhupUHA3iQ=
MIME-Version: 1.0
Date: Mon, 31 May 2010 00:51:50 +0300
Message-ID: <AANLkTinjVwjY88eb9IhxojuerroCY2EqnUy4-J4fQy0o@mail.gmail.com>
Subject: kgdb debugger proxy question - using the same serial port for both 
	serial console and kgdb
From: Paul Fisher <r01.gjk@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason.wessel@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to get kgdb setup working. I have two PCs but unfortunately there is
only one serial port in each of those. So far everything worked great, but
several days ago one of the monitors was taken away from my desk, and the second
machine is now headless.

So now I need some kind of splitter to split the traffic between the gdb and
the minicom (serial console). Since Jason wrote in the kgdb documentation:

> For kgdb/gdb, kgdboc is designed to work with a single serial port. It is
> intended to cover the circumstance where you want to use a serial console
> as our primary console as well as using it to perform kernel debugging.

I assume that such splitter should exist. Moreover, Jason mentions that
'debugger proxy' several times throughout the docs. So I searched the archives
but found only Ingo's mail from 2008 where he asked for a link to such a proxy
but without any response.

After a deeper research I found a kdmx (kgdb demux) script, and in fact it
works, but in a very limited and weird way. For one, you can't send a BRK
(break) from minicom (Ctrl-A f) because it operates on the system call level
(read, write, select syscalls) and the BRK is sent by means of ioctl(). Sending
a break is essential, because that's the way to stop kernel execution and break
into the debugger. Also detach gdb command freezes the whole serial line because
of the way this script is written. I assume that detach is not the only command
that does that...

So does a reliable splitter actually exist? If it doesn't, could you
please share
your experience - briefly describe your kgdb setup? I bet that someone already
had this problem...

Much appreciated,

--paul
