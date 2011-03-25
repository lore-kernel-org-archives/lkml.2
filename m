Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1CYNkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:40:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53598 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1CYNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:40:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: Warning with asm-generic/div64.h
Date: Fri, 25 Mar 2011 14:39:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <007801cbead6$1984b6e0$4c8e24a0$@mprc.pku.edu.cn>
In-Reply-To: <007801cbead6$1984b6e0$4c8e24a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103251439.53568.arnd@arndb.de>
X-Provags-ID: V02:K0:s+53QAXkVdE3Aj3kvdPATRZ0jdVaNf4E7UEFUrpAO56
 rxi89MZBhyNQwyEzZrumvysoSMHCbfFJSRCG5QuAkeFr6plIrw
 ju6ZvcRDI3Umclfzco+SQv/PX75Nvb/1SokPzMuCzYMgNxWcP4
 Is5gmydw947rZN4rBDvP3HA62STG71hBnXJow1tZ7w+3yDjQxu
 3zyTOSCXcnAIGAVlCsAFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011, Guan Xuetao wrote:
> Following warning is generated when using <asm-generic/div64.h>
> 
> kernel/power/hibernate.c: In function 'swsusp_show_speed':
> kernel/power/hibernate.c:227: warning: comparison of distinct pointer types lacks a cast
> 
> After expanding the do_div() macro, the problem line is:
> 
>         (void)(((typeof((n)) *)0) == ((uint64_t *)0));
> 
> while the type of n is s64.
> 
> I am puzzled with the usage of the problem line.
> 
> And how to correct it?

The purpose of this line is to generate a warning when the input is the
wrong type, as the comment says:
 /* The unnecessary pointer compare is there
  * to check for type safety (n must be 64bit)

The macro doesn't work for signed input or for 32 bit input. I'd suggest
fixing the caller to use an unsigned type.

	Arnd

