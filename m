Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab2DJIlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:41:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55189 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2DJIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:40:58 -0400
Message-ID: <4F83F08E.6070304@gmail.com>
Date: Tue, 10 Apr 2012 10:34:22 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.28) Gecko/20120306 SUSE/3.1.20 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] ramoops: use pstore interface
References: <20120117235852.GA4877@www.outflux.net>	<20120118140603.0fc22302.akpm@linux-foundation.org>	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>	<4F1A7854.7010808@gmail.com>	<1333399194.6431.3.camel@lorien2>	<CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com> <20120409143345.a7a8c257.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F170D020E@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170D020E@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/04/2012 23:42, Luck, Tony ha scritto:
>> The patch breaks ramoops module unloading.  Tony says there's "no
>> credible end-user case" for this and Marco promptly provided one,
>> which was ignored.
>
> I'm not sure that I understood Marco's use case. He said:
>
>> First of all ramoops was born mainly for debug purpose and
>> to help the maintainability of a product. I used it in systems
>> where the uptime (so no reboot) was important. So it can be
>> very useful for me load the module, gather logs and unload it
>> for example. A kernel panic is not recoverable so the reboot
>> is needed but it's not always true for a kernel oops.
>
> In the non-crashed oops case ... aren't all the logs you need
> in /var/log/messages?
>
> -Tony

Maybe you right, but it could be useful to have a "single log point" 
especially for automatic/semi-automatic log gathering. I'm not sure we 
can *always* read from messages in case of non-crashed oops. Sure, it 
will be possible after a reboot, but if /var was mounted with tmpfs (on 
embedded systems it's possible :)) we have no log.

PS: It's only a brainstorming on all the possible situation :)

Marco
