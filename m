Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1BIJxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:53:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1BIJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tZQblT2U/PfMe8DkaU+LcbgvCMbPfIQyZPtP3ZLb9PshmK5kRPFJGtab/JZWsF5uGa
         M5EPRBOxFDL8TTbCx0T0Zij3mHq8R8mS+VrLQ6J6XoPy1kd+tC3j8LEnDcqZ4gwDXYVE
         p6bJVZhgQ5q5iIwzEFZ8ic5fOGy5Qjp6gk6l8=
Message-ID: <4D52641E.9020001@suse.cz>
Date: Wed, 09 Feb 2011 10:53:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Tim Deegan <Tim.Deegan@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct	 to
 handle overflow
References: <4D525EF00200007800030F0F@vpn.id2.novell.com> <4D525CA8.60604@suse.cz> <4D526FF40200007800030FEF@vpn.id2.novell.com>
In-Reply-To: <4D526FF40200007800030FEF@vpn.id2.novell.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 10:44 AM, Jan Beulich wrote:
>>>> On 09.02.11 at 10:21, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 02/09/2011 09:31 AM, Jan Beulich wrote:
>>> Fixes a hang when booting as dom0 under Xen, when jiffies can be
>>> quite large by the time the kernel init gets this far.
>>
>> As I wrote this might happen if the boot till this point takes ~ 5
>> minutes because we start at -5 minutes.
>>
>> That said, is this a candidate for stable? (If so, please CC stable.)
> 
> Honestly, I'm not certain (given that mainline Xen Dom0 support
> is still only in its beginnings).

What about other VMs? If I run few non-kvm qemu VMs (kvm presets lpj) on
a busy dual-core machine, this will be a problem too, right?

regards,
-- 
js
suse labs
