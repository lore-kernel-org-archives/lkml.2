Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0HNVAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:00:46 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35298 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0HNVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:00:45 -0400
Date: Sat, 14 Aug 2010 23:00:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
Message-ID: <20100814210044.GA29375@merkur.ravnborg.org>
References: <4C67023D.6050603@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C67023D.6050603@example.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 10:53:17PM +0200, Piotr Hosowicz wrote:
> Hello,
>
> I build new kernels when they become available. Now I have a problem.  
> After I install new kernel I have to run NVidia setup script. Starting  
> from git15 it fails, see attached file. The error line is here:
>
>    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c: At top level:
>    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: error:  
> unknown field ‘ioctl’ specified in initializer
>    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: warning:  
> initialization from incompatible pointer type

The likely culprint is:
b19dd42faf413b4705d4adb38521e82d73fa4249
(bkl: Remove locked .ioctl file operation)

This commit finally killed ioctl from file_operations, as part of the
bkl removal project.


	Sam
