Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0IDM7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:59:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59708 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0IDM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GPShH3+TBVwrnh75oIhA9cuJp/mPT8OzSTUIpSAFt6ZeXweW2rvcXgIhreCKuvpLRE
         t0Ais8/KCgagL997B0LyT9bi3tCE0fGgbZP1fAFpL2Pic6MICDqUG2+M2ujdMOF7c+bQ
         Limr1LBvLwc5h+uWnVP06iHqUzeFrgBFBjhzw=
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove
 of the general version
From: Calvin Walton <calvin.walton@gmail.com>
To: Florian Weimer <fweimer@bfk.de>
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <82mxrzrsvq.fsf@mid.bfk.de>
References: <4C7E2CAC.6080102@cn.fujitsu.com>  <82mxrzrsvq.fsf@mid.bfk.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 08:59:02 -0400
Message-ID: <1283605142.9039.4.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 11:03 +0000, Florian Weimer wrote:
> * Miao Xie:
> 
> >  EXPORT_SYMBOL(memcpy);
> 
> I think you need to change that to EXPORT_SYMBOL_GPL, because the code
> is now licensed under the GPL, and not the GPL plus kernel exceptions
> (whatever they are, but they undoubtly exist), unlike the original
> implementation.

I wouldn't think so - the intent of EXPORT_SYMBOL_GPL is to mark symbols
that make it obvious that a module was derived from the Linux kernel, as
opposed to some sort of generic driver that was just ported to a new
interface. (It's not foolproof, it's more of a warning to developers.)

If you think of it this way, memcpy is a function defined in the C
standard, there's absolutely nothing Linux-specific about using it.

Of course, IANAL; and you should probably grab some more opinions on the
matter.

-- 
Calvin Walton <calvin.walton@gmail.com>

