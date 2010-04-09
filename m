Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0DIUeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:34:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:35713 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754182Ab0DIUeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:34:20 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/Q0Uk3Mc/Q2SQ4/+agH8rJ+adJgXwpN/PzvmFcNZ
	0SRLGl74KP614Y
Message-ID: <4BBF8F48.2070902@gmx.de>
Date: Fri, 09 Apr 2010 22:34:16 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/16] viafb: Determine type of 2D engine and store it
 in chip_info
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>	<1270746946-12467-6-git-send-email-corbet@lwn.net>	<4BBE9CFC.2020804@gmx.de> <20100409141127.42e4e1fa@bike.lwn.net>
In-Reply-To: <20100409141127.42e4e1fa@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> On Fri, 09 Apr 2010 05:20:28 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> Just a minor nit:
>> Could we change the default so that if someone adds support for a new 
>> IGP (and misses this function) we default to either the newest or 
>> preferably to none? I've just seen too much poorly maintained code in 
>> this driver and defaulting to the oldest is hence a bad idea.
>> Otherwise it's fine.
> 
> That would require making an exhaustive list of older chipset types.
> It could probably be inferred through inspection of the code, but I
> worry about making assumptions in this area...

Such list already exists. gfx_chip_name = pdi->driver_data in hw.c (and 
only there) so what is needed is the list viafb_pci_table in viafbdev.c 
(relatively at the end) of all chips:
UNICHROME_CLE266
UNICHROME_PM800
UNICHROME_K400
UNICHROME_K800
UNICHROME_CN700
UNICHROME_K8M890
UNICHROME_CX700
UNICHROME_P4M900
UNICHROME_CN750
UNICHROME_VX800
UNICHROME_VX855

Would appreciate it if you could use this info.


Thanks,

Florian Tobias Schandinat
