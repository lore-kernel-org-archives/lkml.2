Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1INNnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:43:13 -0400
Received: from mail-gw0-f61.google.com ([74.125.83.61]:45088 "EHLO
	mail-gw0-f61.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1INNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:43:13 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 09:43:12 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Wed, 14 Sep 2011 05:57:54 -0700 (PDT)
In-Reply-To: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no>
Reply-To: fa.linux.kernel@googlegroups.com
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=81.164.208.103;
 posting-account=TmuePgoAAADCroGlXr-Y1Eqc_ttgkFy1
NNTP-Posting-Host: 81.164.208.103
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
MIME-Version: 1.0
Message-ID: <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
From: Slawomir Czarko-Wasiutycz <slawomir.czarko@gmail.com>
To: fa.linux.kernel@googlegroups.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 21, 2011 1:28:18 AM UTC+2, Thomas Sattler wrote:
> Hi there ...
> 
> While running firefox (>50 open Tabs), khugepaged jumped to 99.99%
> (according to 'iotop').  I killed firefox and nearly all running
> programs but khugepaged was still at 99.99% IO while the system
> was almost idle. I waited about 10 minutes, no improvement, so
> I rebooted the machine.
> 
Hi,

I have a similar problem.

System becomes unresponsive for few seconds up to a minute or so.

In my case the trigger seems to be compiling code in a Linux VM running in VMplayer.

Problem seems to go away if I do:

echo madvise > /sys/kernel/mm/transparent_hugepage/defrag

Kernel used: kernel-PAE-2.6.40.4-5.fc15.i686 SMP CONFIG_PREEMPT=n

Right now I'm trying the same kernel with CONFIG_PREEMPT=y and it looks like the problem doesn't occur.
