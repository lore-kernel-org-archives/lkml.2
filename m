Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0HRTBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:01:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0HRTBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qCniJIWTjHMtjZmSDxuQx/tfp4Pxy1gpmcG0oUcHZuB2MX25DdZHvuvKbQDGQIXg/+
         3I6jhg90mrF23nUl6tUkeymz1EoQHoC+TAVj5aIfiHo+5IHxOqk5Xo8NoABh65wBYKJ0
         o3aQd0WVjE/eCOfiI8M63zEFuyoBY/VgpU96U=
Message-ID: <4C6C2DE9.2000509@gmail.com>
Date: Wed, 18 Aug 2010 21:00:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christian Samsel <Christian.Samsel@rwth-aachen.de>
CC: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: runaway loop modprobe char-major-5-1 has returned?
References: <201008181143.04629.Christian.Samsel@rwth-aachen.de>
In-Reply-To: <201008181143.04629.Christian.Samsel@rwth-aachen.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 11:43 AM, Christian Samsel wrote:
> Hi,
> I wanted to build a minimal kernel as Xen DomU, but stumbled across
> 
> [    0.029457] VFS: Disk quotas dquot_6.5.2
> [    0.029559] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.029973] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    0.030662] msgmni has been set to 243
> [    0.099708] request_module: runaway loop modprobe char-major-5-1
> [    0.100482] request_module: runaway loop modprobe char-major-5-1
> [    0.101851] request_module: runaway loop modprobe char-major-5-1
> [    0.102534] request_module: runaway loop modprobe char-major-5-1
> [    0.106311] request_module: runaway loop modprobe char-major-5-1
> (hangs)
> 
> after reading http://lwn.net/Articles/310472/ and comparing the output after 
> msgmni of a working kernel on a other machine i found the config option change 
> which breaks it:

Hi, you may want this:
31d1d48e199e99077fb30f6fb9a793be7bec756f

Adding stable to consider it for inclusion in .35 stable too.

-- 
js
