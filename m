Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0C0OiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:38:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0C0OiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:38:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Sat, 27 Mar 2010 15:37:38 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <201003251438.59062.arnd@arndb.de> <4BAD4795.2040700@s5r6.in-berlin.de>
In-Reply-To: <4BAD4795.2040700@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003271537.40488.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LdXSnm0gS4Hzna88NRYqPW/VOlWhPVh0r1Oq
 Fj/5oTyLmW7s1oI4Yub8EA7i9r5OfiQML1plRIczpcNFAMP73R
 omWlBoGIoK30fufpuHZEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 March 2010 00:47:33 Stefan Richter wrote:

> firewire-core and raw1394 do not actually require the BKL, they only
> miss to declare their files as not seekable.  I will post patches which
> change these accordingly.
> 
> My guess is that there is nothing to seek in dv1394, video1394, and
> firedtv either.
> 
> Needless to say, there may be other character device file interfaces
> which cannot be seeked but don't admit it yet.
> 

Your patches look good, but it would be helpful to also set .llseek = no_llseek
in the file operations, because that is much easier to grep for than
only the nonseekable_open. While it's technically a NOP on the presence of
nonseekable_open, it will help that I don't accidentally apply my patch on
top of yours.

	Arnd
