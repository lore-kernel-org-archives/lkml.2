Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab1ADWKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:10:46 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:40491 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1ADWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:10:45 -0500
Message-ID: <4D239AE1.10003@bwalle.de>
Date: Tue, 04 Jan 2011 23:10:41 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Leo Prasath <leo.prasath@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Null pointer exception for local variables in stack with C++
 kernel modules
References: <AANLkTimH+xa3Na6Y+M=UNZSfjph5etyTtc=v2TMdqwHj@mail.gmail.com> <AANLkTik_dFBq5=GDB3tmiN0N=hc1iaif0hv4URnm2f5b@mail.gmail.com>
In-Reply-To: <AANLkTik_dFBq5=GDB3tmiN0N=hc1iaif0hv4URnm2f5b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: kernel@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Leo,

Am 04.01.11 20:46, schrieb Leo Prasath:
> 
> I have integrated a C++ codebase which uses minimalistic features of c
> and followed the guidelines in
> http://pograph.wordpress.com/2009/04/05/porting-cpp-code-to-linux-kernel/
> to integrate with an existing C linux kernel module.
> It all works fine except for occassional very very weird NULL pointer
> exceptions.

Wild guess: Stack overflow. In the kernel the stack is very limited
(depends on the configuration and IIRC on the archtecture, but 4K is the
minimum IIRC) and in C++ it's possible and common to put larger objects
on the stack.

However, C++ isn't supported by the kernel developers and you're on your
own. Rewrite the code to use plain C.


Regards,
Bernhard
